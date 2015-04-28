title: A Simpler Responsive Grid
article_id: 12
slug: a-simpler-responsive-grid

#!!==========================================================

{{imageraw: 1}}

After making use of various complicated CSS grid systems, I’ve been using a simple percentage-based grid for the last fyear or so. It’s based on a 1000 pixel wide container with 63 pixel columns and 20 pixel gutters. The outside gutters at the extreme left/right are 12 pixels to produce a nice round number.

By using a 1000 pixel wide container, the maths is easy when using percentages. each column is 6.3%, gutters are 2% and so on…

By setting a width on the container of 100% and a max-width of 1000 pixels, and thereafter using percentages for all widths, everything resizes nicely:

````css
#container {
    margin: 0 auto;    
    max-width: 1000px;
    width: 100%;
  }

  #my-box {
    width: 14.6% /* Two columns wide - (2 * 6.3)+2 */
    margin-left: 1.2% /* Covering the first two columns */
  }
````

I’ve knocked together a quick [example page](http://dasmith.co.uk/files/examples/grid.html) ([code](https://gist.github.com/2875987)) that shows the columns. One problem with percentage-based widths is that because of the box model, any borders or padding will be added onto outside of the box. Obviously this can be a drama if you’re using pixels to declare your borders and padding.

The easy solution to this is the box-sizing property:

````css
#my-other-box {
    width: 31.2% /* Four columns wide */
    margin-left: 9.5% /* Covering columns 2 to 5 (1.2 + 6.3 + 2) */

    box-sizing: border-box;
    border: 2px solid red; /* will be rendered inside the box */
  }
````

Although this solution isn’t always ideal, particularly at smaller viewport widths, it’s better for me than using other peoples complex grid systems.
