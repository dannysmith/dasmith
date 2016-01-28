title: Styleguide
article_id: 16
slug: styleguide

#!!==========================================================

The first paragraph is styled in a different way to the others. Lorem ipsum dolor sit amet, consectetur adipisicing elit. Cupiditate animi ratione recusandae rem dolore blanditiis suscipit, beatae neque molestias perferendis architecto, eaque id aut, deleniti magni sit voluptate reprehenderit consequatur.

Subsequent paragraphs are styled more normally. Lorem ipsum dolor sit amet, consectetur adipisicing elit. Enim optio laudantium mollitia suscipit culpa odit, beatae iusto consequatur perferendis molestiae porro ab quia amet possimus at saepe expedita, sint maiores!

---

# Headings

### Rendered:

# Heading One
Subsequent paragraphs are styled more normally. Lorem ipsum dolor sit amet, consectetur adipisicing elit.

## Heading Two
Subsequent paragraphs are styled more normally. Lorem ipsum dolor sit amet, consectetur adipisicing elit.

### Heading Three
Subsequent paragraphs are styled more normally. Lorem ipsum dolor sit amet, consectetur adipisicing elit.

#### Heading Four
Subsequent paragraphs are styled more normally. Lorem ipsum dolor sit amet, consectetur adipisicing elit.

##### Heading Five
Subsequent paragraphs are styled more normally. Lorem ipsum dolor sit amet, consectetur adipisicing elit.

### Markdown:

```markdown
# Heading One
Subsequent paragraphs are styled more normally. Lorem ipsum dolor sit amet, consectetur adipisicing elit.

## Heading Two
Subsequent paragraphs are styled more normally. Lorem ipsum dolor sit amet, consectetur adipisicing elit.

### Heading Three
Subsequent paragraphs are styled more normally. Lorem ipsum dolor sit amet, consectetur adipisicing elit.

#### Heading Four
Subsequent paragraphs are styled more normally. Lorem ipsum dolor sit amet, consectetur adipisicing elit.

##### Heading Five
Subsequent paragraphs are styled more normally. Lorem ipsum dolor sit amet, consectetur adipisicing elit.
```

### HTML:

```html
<h1>Heading One</h1>
<p>Subsequent paragraphs are styled more normally. Lorem ipsum dolor sit amet, consectetur adipisicing elit.</p>
<h2>Heading Two</h2>
<p>Subsequent paragraphs are styled more normally. Lorem ipsum dolor sit amet, consectetur adipisicing elit.</p>
<h3>Heading Three</h3>
<p>Subsequent paragraphs are styled more normally. Lorem ipsum dolor sit amet, consectetur adipisicing elit.</p>
<h4>Heading Four</h4>
<p>Subsequent paragraphs are styled more normally. Lorem ipsum dolor sit amet, consectetur adipisicing elit.</p>
<h5>Heading Five</h5>
<p>Subsequent paragraphs are styled more normally. Lorem ipsum dolor sit amet, consectetur adipisicing elit.</p>
```


---

# Lists

### Rendered:

- One
- Two
- Three
    + Four
    + Five Six
        * Seven
        * Eight
- Four

### Markdown:

```markdown
- One
- Two
- Three
    + Four
    + Five Six
        * Seven
        * Eight
- Four

```

### HTML:

```html
<ul>
  <li>One</li>
  <li>Two</li>
  <li>Three</li>
  <li>
    <ul>
      <li>Four</li>
      <li>Five Six</li>
      <li>
        <ul>
          <li>Seven</li>
          <li>Eight</li>
        </ul>
      </li>
    </ul>
  </li>
  <li>Four</li>
</ul>
```

---

# Aside

### Rendered:

aside> Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quod, beatae, dolorem. Nostrum exercitationem perferendis provident nihil aliquam laboriosam, numquam sequi, obcaecati fugit earum culpa, temporibus accusantium cum doloribus iusto eveniet!

### Markdown:

```markdown
aside> Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quod, beatae, dolorem. Nostrum exercitationem perferendis provident nihil aliquam laboriosam, numquam sequi, obcaecati fugit earum culpa, temporibus accusantium cum doloribus iusto eveniet!
```

### HTML:

```html
<aside class="c-aside"><i class="u-icon u-icon-tags u-icon-2x pull-left"></i> Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quod, beatae, dolorem. Nostrum exercitationem perferendis provident nihil aliquam laboriosam, numquam sequi, obcaecati fugit earum culpa, temporibus accusantium cum doloribus iusto eveniet!</aside>
```



---



# Bold, Italic, Superscript and Underline

### Rendered:

Lorem ipsum dolor^sit amet, consectetur **adipisicing elit**. Ex perspiciatis nemo rerum *necessitatibus laboriosam* neque error numquam facere harum facilis itaque eos eveniet sint alias, _reiciendis_, saepe magni maiores porro!

### Markdown:

```markdown
Lorem ipsum dolor^sit amet, consectetur **adipisicing elit**. Ex perspiciatis nemo rerum *necessitatibus laboriosam* neque error numquam facere harum facilis itaque eos eveniet sint alias, _reiciendis_, saepe magni maiores porro!
```

### HTML:

```html
Lorem ipsum dolor<sup>sit</sup> amet, consectetur <strong>adipisicing elit</strong>. Ex perspiciatis nemo rerum <em>necessitatibus laboriosam</em> neque error numquam facere harum facilis itaque eos eveniet sint alias, <u>reiciendis</u>, saepe magni maiores porro!
```



---


# Strikethrough and Marked Text

### Rendered:

Lorem ipsum ~~dolor sit amet, consectetur adipisicing elit~~. Quo nesciunt ad molestiae quisquam unde rerum enim. Rem aliquam, ==tenetur officiis esse! Quaerat cupiditate placeat hic ab necessitatibus== quisquam id beatae.

### Markdown:

```markdown
Lorem ipsum ~~dolor sit amet, consectetur adipisicing elit~~. Quo nesciunt ad molestiae quisquam unde rerum enim. Rem aliquam, ==tenetur officiis esse! Quaerat cupiditate placeat hic ab necessitatibus== quisquam id beatae.
```

### HTML:

```html
Lorem ipsum <del>dolor sit amet, consectetur adipisicing elit</del>. Quo nesciunt ad molestiae quisquam unde rerum enim. Rem aliquam, <mark>tenetur officiis esse! Quaerat cupiditate placeat hic ab necessitatibus</mark> quisquam id beatae.
```



---



# Links and Footnotes

### Rendered:

Lorem ipsum dolor[^1] sit amet, consectetur[^2] adipisicing elit. Minus ipsa ad saepe illo, [illum itaque](http://google.com) vero doloremque sint totam laudantium cum aspernatur dolores [voluptate a, in perspiciatis](http://google.com), minima aliquid sed!

[^1]: This is the first footnote.
[^2]: This is the [second](http://google.com) footnote.

### Markdown:

```markdown
Lorem ipsum dolor[^1] sit amet, consectetur[^2] adipisicing elit. Minus ipsa ad saepe illo, [illum itaque](http://google.com) vero doloremque sint totam laudantium cum aspernatur dolores [voluptate a, in perspiciatis](http://google.com), minima aliquid sed!

[^1]: This is the first footnote.
[^2]: This is the [second](http://google.com) footnote.
```

### HTML:

```html
Lorem ipsum dolor<sup><a href="#fn1" rel="footnote">1</a></sup> sit amet, consectetur<sup><a href="#fn2" rel="footnote">2</a></sup> adipisicing elit. Minus ipsa ad saepe illo, <a href="http://google.com">illum itaque</a> vero doloremque sint totam laudantium cum aspernatur dolores <a href="http://google.com">voluptate a, in perspiciatis</a>, minima aliquid sed!
```



---

# Inline code and keyboard blocks

### Rendered:

Lorem ipsum dolor sit amet, `consectetur adipisicing` elit. Nostrum hic saepe laboriosam <kbd>CMD</kbd> laborum quidem, voluptatum dolores eius blanditiis quisquam natus! Adipisci minima vitae, culpa nobis optio, eligendi at repellat.

### Markdown:

```markdown
Lorem ipsum dolor sit amet, `consectetur adipisicing` elit. Nostrum hic saepe laboriosam <kbd>CMD</kbd> laborum quidem, voluptatum dolores eius blanditiis quisquam natus! Adipisci minima vitae, culpa nobis optio, eligendi at repellat.
```

### HTML:

```html
Lorem ipsum dolor sit amet, <code class="prettyprint">consectetur adipisicing</code> elit. Nostrum hic saepe laboriosam <kbd>nulla</kbd> laborum quidem, voluptatum dolores eius blanditiis quisquam natus! Adipisci minima vitae, culpa nobis optio, eligendi at repellat.
```



---

# Blockquote

### Rendered:

> Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quod, beatae, dolorem. Nostrum exercitationem perferendis provident nihil aliquam laboriosam, numquam sequi, obcaecati fugit earum culpa, temporibus accusantium cum doloribus iusto eveniet! -- Danny Smith


### Markdown:

```markdown
> Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quod, beatae, dolorem. Nostrum exercitationem perferendis provident nihil aliquam laboriosam, numquam sequi, obcaecati fugit earum culpa, temporibus accusantium cum doloribus iusto eveniet! -- Danny Smith

```

### HTML:

```html
<blockquote class="c-blockquote o-pull-block o-pull-block--left">
  <div class="c-blockquote__content o-pull-block__content">
    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quod, beatae, dolorem. Nostrum exercitationem perferendis provident nihil aliquam laboriosam, numquam sequi, obcaecati fugit earum culpa, temporibus accusantium cum doloribus iusto eveniet!</p>
  </div>
  <footer class="c-blockquote__footer o-pull-block__footer">
  <span> Danny Smith</span>
  </footer>
</blockquote>
```


---

# Breaking pre blocks

### Rendered:

<pre class="u-code">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Cupiditate labore tenetur ut architecto voluptatum reiciendis aut perspiciatis quod, eius nihil esse officiis, at sed laudantium ab amet ipsum doloremque eaque.
</pre>

### Markdown:

```markdown
<pre class="u-code">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Cupiditate labore tenetur ut architecto voluptatum reiciendis aut perspiciatis quod, eius nihil esse officiis, at sed laudantium ab amet ipsum doloremque eaque.
</pre>
```

### HTML:

```html
<pre class="u-code">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Cupiditate labore tenetur ut architecto voluptatum reiciendis aut perspiciatis quod, eius nihil esse officiis, at sed laudantium ab amet ipsum doloremque eaque.
</pre>
```



---


# Images

### Rendered:

{{image: 1}}

### Markdown:

```markdown
{{image: 1}}
```

### HTML:

```html
<figure class="o-pull-block o-pull-block--left c-image-figure">
  <a class="o-pull-block__content" href="/article-images/16-1-Definition-of-Agile.png">
    <img src="/article-images/16-1-Definition-of-Agile.png" alt="Definition of agile">
  </a>
  <figcaption class="o-pull-block__footer">Definition of agile</figcaption>
</figure>
```



---


# Raw Images

### Rendered:

{{imageraw: 1}}

### Markdown:

```markdown
{{imageraw: 1}}
```

### HTML:

```html
<img src="/article-images/16-1-Definition-of-Agile.png" alt="Definition of agile">
```


---


# Tables

### Rendered:

First Header  | Second Header | Third Header
------------- | ------------- | ------------
Content Cell  | Content Cell  | Content Cell
Content Cell  | Content Cell  | Content Cell
Content Cell  | Content Cell  | Content Cell

### Markdown:

```markdown
First Header  | Second Header | Third Header
------------- | ------------- | ------------
Content Cell  | Content Cell  | Content Cell
Content Cell  | Content Cell  | Content Cell
Content Cell  | Content Cell  | Content Cell
```

### HTML:

```html
<div class="table-wrapper">
  <table>
<tbody><tr>
<th>First Header</th>
<th>Second Header</th>
<th>Third Header</th>
</tr>
<tr>
<td>Content Cell</td>
<td>Content Cell</td>
<td>Content Cell</td>
</tr>
<tr>
<td>Content Cell</td>
<td>Content Cell</td>
<td>Content Cell</td>
</tr>
<tr>
<td>Content Cell</td>
<td>Content Cell</td>
<td>Content Cell</td>
</tr>

  </tbody></table>
</div>
```



---


# Standard Code Blocks

### Rendered:

````ruby
def mything(foo)
  thing = "foo"
  @bar = [1,2,3]
end
````

### Markdown:

~~~markdown
````ruby
def mything(foo)
  thing = "foo"
  @bar = [1,2,3]
end
\```
~~~

### HTML:

```html
<div class="highlight highlight-ruby">
  <pre>
    <span id="line-1"><span class="k">def</span> <span class="nf">mything</span><span class="p">(</span><span class="n">foo</span><span class="p">)</span></span>
    <span id="line-2">  <span class="n">thing</span> <span class="o">=</span> <span class="s2">"foo"</span></span>
    <span id="line-3">  <span class="vi">@bar</span> <span class="o">=</span> <span class="o">[</span><span class="mi">1</span><span class="p">,</span><span class="mi">2</span><span class="p">,</span><span class="mi">3</span><span class="o">]</span></span>
    <span id="line-4"><span class="k">end</span></span>
  </pre>
</div>
```


---


# Markdown code Blocks

### Rendered:

```markdown
Lorem ipsum dolor sit amet, consectetur adipisicing elit. Neque labore id harum. Hic accusamus, mollitia velit, quidem fugit voluptatum minus odio quam quae aliquid nam iusto facere sapiente maiores autem.
```

### Markdown:

~~~markdown
```markdown
Lorem ipsum dolor sit amet, consectetur adipisicing elit. Neque labore id harum. Hic accusamus, mollitia velit, quidem fugit voluptatum minus odio quam quae aliquid nam iusto facere sapiente maiores autem.
\```
~~~

### HTML:

```html
<div class="highlight highlight-markdown">
  <pre>
    <span id="line-1">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Neque labore id harum. Hic accusamus, mollitia velit, quidem fugit voluptatum minus odio quam quae aliquid nam iusto facere sapiente maiores autem.</span>
  </pre>
</div>
```

