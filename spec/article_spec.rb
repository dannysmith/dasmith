require 'spec_helper'

describe DannyIs::Article do

  let(:image1) { instance_double('DannyIs::ArticleImage', filename: '2-1-this-is-file-one.png',
                                       order: 1,
                                       title: 'This is file one',
                                       url: '/article-images/2-1-this-is-file-one.png') }
  let(:image2) { instance_double('DannyIs::ArticleImage', filename: '2-2-this-is-file-two.png',
                                       order: 2,
                                       title: 'This is file two',
                                       url: '/article-images/2-2-this-is-file-two.png') }

  article1_path = "testdata/20150101-This-is-Article-One.md"
  article2_path = "testdata/20150102-This-is-Article-Two-One.md"
  article_draft_path = "testdata/drafts/20150104-This-is-a-draft.md"
  article1_content = "article_id: 1
title: This is the title
slug: this-is-the-slug

#!!===================================

# This is the markdown"

  article2_content = "article_id: 2
title: This is yet another article
slug: another-article

#!!===================================

# This is the markdown"

  article_draft_content = "article_id: 5
title: This is A DRAFT ARTICLE
slug: draft-article

#!!===================================

# Draft: This is a Draft"

  before(:all) do
    Dir.mkdir('testdata')
    Dir.mkdir('testdata/drafts')
    File.write(article1_path, article1_content)
    File.write(article2_path, article2_content)
    File.write(article_draft_path, article_draft_content)
  end

  after(:all) do
    FileUtils.rm_rf('testdata')
  end

  before(:each) do
    DannyIs::Article.class_variable_set :@@articles, []
  end

  it "should create a new article correctly" do
    allow(DannyIs::ArticleImage).to receive(:load).and_return([image1, image2])
    article = DannyIs::Article.new(article1_path)

    expect(article.article_id).to eq 1
    expect(article.body).to eq "<h1>This is the markdown</h1>\n"
    expect(article.body_as_markdown).to eq article1_content
    expect(article.images.size).to eq 2
    expect(article.date).to eq DateTime.parse '20150101'
    expect(article.slug).to eq 'this-is-the-slug-150101'
    expect(article.title).to eq 'This is the title'
  end

  context "The configure block" do

    before do
      # Stub out puts to supress terminal output.
      allow($stdout).to receive(:puts)
    end

    it "should set the correct class variables" do
      DannyIs::Article.configure do |config|
        config.articles_path = 'articles/path'
        config.draft_articles_path = 'articles/path/drafts'
        config.images_path = 'public/images'
        config.articles_per_page = 5
        config.development_mode = true
      end

      expect(DannyIs::Article.articles_path).to eq 'articles/path'
      expect(DannyIs::Article.draft_articles_path).to eq 'articles/path/drafts'
      expect(DannyIs::Article.images_path).to eq 'public/images'
      expect(DannyIs::Article.articles_per_page).to eq 5
      expect(DannyIs::Article.development_mode).to eq true
    end

    it "should read in all articles including drafts when in dev mode" do
      allow(DannyIs::ArticleImage).to receive(:load).and_return([image1, image2])

      DannyIs::Article.configure do |config|
        config.articles_path = '../testdata'
        config.draft_articles_path = '../testdata/drafts'
        config.images_path = 'public/images'
        config.articles_per_page = 2
        config.development_mode = true
      end

      expect(DannyIs::Article.all.size).to eq 3
      expect(DannyIs::Article.all[0].title).to include 'DRAFT'
    end

    it "should read in all articles EXCEPT drafts when not in dev mode" do
      allow(DannyIs::ArticleImage).to receive(:load).and_return([image1, image2])

      DannyIs::Article.configure do |config|
        config.articles_path = '../testdata'
        config.draft_articles_path = '../testdata/drafts'
        config.images_path = 'public/images'
        config.articles_per_page = 2
        config.development_mode = false
      end

      expect(DannyIs::Article.all.size).to eq 2
      expect(DannyIs::Article.all[0].title).not_to include 'DRAFT'
    end
  end

  context do
    before(:each) do
      # Stub out puts to supress terminal output.
      allow($stdout).to receive(:puts)

      # Create a mock DannyIs::ArticleImage class
      allow(DannyIs::ArticleImage).to receive(:load).and_return([image1, image2])

      DannyIs::Article.configure do |config|
        config.articles_path = '../testdata'
        config.draft_articles_path = '../testdata/drafts'
        config.images_path = 'public/images'
        config.articles_per_page = 2
        config.development_mode = true
      end
    end
    context 'The class should' do

      it "return the latest article" do
        article = DannyIs::Article.latest
        expect(article).to be_a DannyIs::Article
        expect(article.article_id).to eq 5
      end

      it "return all the articles in descending date order" do
        articles = DannyIs::Article.all
        expect(articles).to be_a Array
        expect(articles.size).to eq 3
        expect(articles[0].date).to be > articles[1].date
      end

      it "page articles correctly" do
        page1 = DannyIs::Article.all(page: 1)
        page2 = DannyIs::Article.all(page: 2)
        page3 = DannyIs::Article.all(page: 3)

        expect(page1.size).to eq 2
        expect(page1[0].date).to be > page1[1].date
        expect(page2.size).to eq 1
        expect(page1[1].date).to be > page2[0].date
        expect(page3).to eq []
      end

      it "should return paged articles" do
        pages = DannyIs::Article.pages

        expect(pages[0].size).to eq 2
        expect(pages[0][0].date).to be > pages[0][1].date
        expect(pages[1].size).to eq 1
        expect(pages[0][1].date).to be > pages[1][0].date
      end

      it "should not publish future articles" do
        future_article = DannyIs::Article.all[1]
        allow(future_article).to receive(:date).and_return(Date.today+365)

        expect(DannyIs::Article.published.size).to eq 2
        expect(DannyIs::Article.published[1].article_id).not_to be 2
      end

      it "should find articles by their id" do
        expect(DannyIs::Article.find(id: 2).article_id).to eq 2
      end

      it "should find articles by their slug" do
        expect(DannyIs::Article.find(slug: 'this-is-the-slug-150101').article_id).to eq 1
      end
    end

    context 'An instance should' do
      it "respond to next" do
        expect(DannyIs::Article.find(id: 2).newer.article_id).to eq 5
        expect(DannyIs::Article.find(id: 5).newer).to eq nil
      end

      it "respond to previous" do
        expect(DannyIs::Article.find(id: 2).older.article_id).to eq 1
        expect(DannyIs::Article.find(id: 1).older).to eq nil
      end
    end
  end
end
