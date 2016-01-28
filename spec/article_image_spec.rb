require 'spec_helper'

describe DannyIs::ArticleImage do

  before(:all) do
    Dir.mkdir('testdata') unless Dir.exists?('testdata')
  end

  after(:all) do
    FileUtils.rm_rf('testdata')
  end

  it "should create a new article image correctly" do
    # Setup
    image_path = "testdata/2-3-this-is-file-one.png"
    File.write(image_path, "")

    # Condition
    image = DannyIs::ArticleImage.new image_path

    # Assertions
    expect(image.filename).to eq "2-3-this-is-file-one.png"
    expect(image.order).to eq 3
    expect(image.title).to eq "This is file one"
    expect(image.url).to eq "/article-images/2-3-this-is-file-one.png"

    # Teardown
    File.delete(image_path)
  end

  it "should read in images for a secified article" do
    # Setup
    image_paths = ["testdata/2-3-this-is-file-one.png", "testdata/2-1-this-is-file-two.png"]
    image_paths.each { |path| File.write(path, "") }

    images = DannyIs::ArticleImage.load load_path: '../testdata',
                                        article_id: 2

    expect(images).to be_a Array
    expect(images.length).to eq 2
    expect(images[0]).to be_an DannyIs::ArticleImage

    # Teardown
    image_paths.each { |path| File.delete(path) }
  end

  it "should return an empty array if there are no images matching" do
    images = DannyIs::ArticleImage.load load_path: '../testdata',
                                        article_id: 20
    expect(images).to eq []
  end

  it "should return an error if load_path is omitted" do
    expect { DannyIs::ArticleImage.load article_id: 2 }.to raise_error ArgumentError
  end

  it "should return an error if article_id is omitted" do
    expect { DannyIs::ArticleImage.load load_path: '../testdata' }.to raise_error ArgumentError
  end
end
