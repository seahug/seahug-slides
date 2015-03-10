<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>SeaHUG March 2015</title>
  <meta name="description" content="Slide deck for SeaHUG meeting March 2015"/>
  <meta name="author" content="Richard Cook"/>

  <!-- SlidesJS Required (if responsive): Sets the page width to the device width. -->
  <meta name="viewport" content="width=device-width"/>
  <!-- End SlidesJS Required -->

  <!-- CSS for slidesjs.com example -->
  <link rel="stylesheet" href="css/example.css"/>
  <link rel="stylesheet" href="css/font-awesome.min.css"/>
  <!-- End CSS for slidesjs.com example -->

  <!-- SlidesJS Optional: If you'd like to use this design -->
  <style>
    body {
      -webkit-font-smoothing: antialiased;
      font: normal 15px/1.5 "Helvetica Neue", Helvetica, Arial, sans-serif;
      color: #232525;
      padding-top:70px;
    }

    #slides {
      display: none
    }

    #slides .slidesjs-navigation {
      margin-top:3px;
    }

    #slides .slidesjs-previous {
      margin-right: 5px;
      float: left;
    }

    #slides .slidesjs-next {
      margin-right: 5px;
      float: left;
    }

    .slidesjs-pagination {
      margin: 6px 0 0;
      float: right;
      list-style: none;
    }

    .slidesjs-pagination li {
      float: left;
      margin: 0 1px;
    }

    .slidesjs-pagination li a {
      display: block;
      width: 13px;
      height: 0;
      padding-top: 13px;
      background-image: url(img/pagination.png);
      background-position: 0 0;
      float: left;
      overflow: hidden;
    }

    .slidesjs-pagination li a.active,
    .slidesjs-pagination li a:hover.active {
      background-position: 0 -13px
    }

    .slidesjs-pagination li a:hover {
      background-position: 0 -26px
    }

    #slides a:link,
    #slides a:visited {
      color: #333
    }

    #slides a:hover,
    #slides a:active {
      color: #9e2020
    }

    .navbar {
      overflow: hidden
    }
  </style>
  <!-- End SlidesJS Optional-->

  <!-- SlidesJS Required: These styles are required if you'd like a responsive slideshow -->
  <style>
    #slides {
      display: none
    }

    .container {
      margin: 0 auto
    }

    /* For tablets & smart phones */
    @media (max-width: 767px) {
      body {
        padding-left: 20px;
        padding-right: 20px;
      }
      .container {
        width: auto
      }
    }

    /* For smartphones */
    @media (max-width: 480px) {
      .container {
        width: auto
      }
    }

    /* For smaller displays like laptops */
    @media (min-width: 768px) and (max-width: 979px) {
      .container {
        width: 724px
      }
    }

    /* For larger displays */
    @media (min-width: 1200px) {
      .container {
        width: 1170px
      }
    }

    .container {
      background-image: url("img/HaskellLogoStyPreview-1.png");
      background-repeat: no-repeat;
      background-position: right bottom;
    }

    .code {
      margin-left: 2em;
      color: purple;
      font-family: Monospace;
      font-size: 110%;
      font-weight: bold;
    }

    tt {
      color: purple;
      font-weight: bold;
    }
  </style>
  <!-- SlidesJS Required: -->
</head>
<body>

  <!-- SlidesJS Required: Start Slides -->
  <!-- The container is used to define the width of the slideshow -->
  <div class="container">
    <div id="slides">
      <div>
        <h2>Help me do this idiomatically</h2>
        <div class="code">
          <code-snippet file="snippets/folds.hs"/>
        </div>
        <ul>
          <li>Should I use <tt>foldl'</tt> or <tt>foldr</tt> instead?</li>
          <li>If so, is it straightforward to maintain the ordering?</li>
          <li>Is there a more idiomatic way to do this kind of thing?</li>
          <li>How do I refactor this to use state monad?</li>
          <li>Should I refactor this to use state monad?</li>
        </ul>
      </div>
      <div>
        <h2><tt>x : xs</tt> efficiency problem mentioned in <em>Real World Haskell</em></h2>
        <ul>
          <li>Source: page 41 of <em>Real World Haskell</em></li>
          <li>Link: <a href="http://book.realworldhaskell.org/read/functional-programming.html#fp.aspatterns">http://book.realworldhaskell.org/read/functional-programming.html#fp.aspatterns</a></li>
        </ul>
        <div class="code">
          <code-snippet file="snippets/as-patterns.hs"/>
        </div>
        <ul>
          <li>Claim is that <tt>asPattern</tt> is more efficient than <tt>noAsPattern</tt></li>
          <li>There are many comments about this in annotated online version of book</li>
          <li>Given how sophisticated GHC is reputed to be, it would worry me if the fairly obvious optimization isn't automatic</li>
          <li>What's the consensus?</li>
        </ul>
      </div>
      <div>
        Language extension of interest: view patterns
      </div>
      <div>
        Heist and how I generated this slide deck!
      </div>
      <div class="code">
        <code-snippet file="HelloWorld.hs"/>
      </div>
      <a href="#" class="slidesjs-previous slidesjs-navigation"><i class="icon-chevron-left icon-large"></i></a>
      <a href="#" class="slidesjs-next slidesjs-navigation"><i class="icon-chevron-right icon-large"></i></a>
    </div>
  </div>
  <!-- End SlidesJS Required: Start Slides -->

  <!-- SlidesJS Required: Link to jQuery -->
  <script src="js/jquery-1.9.1.min.js"></script>
  <!-- End SlidesJS Required -->

  <!-- SlidesJS Required: Link to jquery.slides.js -->
  <script src="js/jquery.slides.min.js"></script>
  <!-- End SlidesJS Required -->

  <!-- SlidesJS Required: Initialize SlidesJS with a jQuery doc ready -->
  <script>
    $(function() {
      $('#slides').slidesjs({
        width: 940,
        height: 428,
        navigation: false
      });

      $(window).keyup(function(e) {
        var key = e.which | e.keyCode;
        if (key === 37) { // Left arrow
          $("a.slidesjs-previous").click();
        }
        else if (key === 39) { // Right arrow
          $("a.slidesjs-next").click();
        }
      });
    });
  </script>
  <!-- End SlidesJS Required -->
</body>
</html>
