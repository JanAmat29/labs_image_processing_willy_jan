#import "@preview/typsidian:0.0.1": *
#import calc: round, abs


#set page(
  margin: (top: 5.2cm, left: 1.2cm, right: 1.2cm, bottom: 1.5cm),
  header: {
    let darkred = rgb("#b11226")

    stack(
      spacing: 0.45em,

      // Top left course title
      text(fill: darkred, size: 14pt, weight: "bold")[Image Processing 2026],

      // Logo on the left, students on the right
      grid(
        columns: (auto, 1fr),
        gutter: 0.9em,

        [#image("img/UPFt_rgb.png", width: 50%)],

        [
          #align(right)[
            #text(size: 10pt, fill: black)[Jan Amat Pallejà u251324]\
            #text(size: 10pt, fill: black)[Guillem Esplugas Martínez u251682]
          ]
        ],
      ),
    v(0.5cm),
          // Line + title on the same row
      grid(
        columns: (1fr, auto),
        gutter: 0.6em,

        [#line(length: 100%, stroke: 0.6pt + black)],

        [#text(size: 16pt, weight: "bold", fill: black)[Assignment Lab 4]],
      ),
    )
  },
)

#set text(font: "Computer Modern", size: 11pt, lang: "en", fill: black)
#set par(justify: true, leading: 0.85em)
#show figure.caption: set text(size: 0.85em)

#align(center)[
  #text(size: 24pt, weight: "bold")[Mathematical morphology]
]

#set heading(numbering: "1.")

#set text(size: 11pt)

/* Example of showing a figure:
#figure(
  image("img/low_contrast.png", width: 25%),
  caption: "Original low contrast image."
)<LowContrastImage>
*/

/* Example of showing a figure with multiple subfigures:
  #grid(
  columns: (1fr, 1fr),
  gutter: 1em,

  [
    #figure(
      image("img/lena_color.png", width: 60%),
      caption: "Original RGB image."
    )<LenaColorImage>
  ],

  [
    #figure(
      image("img/lena.png", width: 60%),
      caption: "Original grayscale image."
    )<LenaGrayImage>
  ],
  )
*/

= MORPHOLOGICAL SEPARATION, RESTORATION, AND BOUNDARY EXTRACTION

/* Exercise 1.
As seen in the following Figure, Evarist and Ermessenda just started dating.
Perform the following tasks:
• Dueto some random reasons, you do not want to see them holding hands. Apply morphological filters to avoid it.
• Belive it or not, someone hated evenmorethesituation and shot them. Fortunately, this is just a picture, but both guys have holes in their bodies; use morphology to heal them.
• Getthe boundaries of the holding-hands couple. */



= SEGMENTATION OF LETTERS

/* Exercise 2.
Find a proper segmentation of the image letters.png separating the letters from the background. */



= SEGMENTATION OF NOISY LETTERS

/* Exercise 3.
Drawthree letters in a blank image with a any kind of Drawing software (Gimp or Paint work fine); introduce noise to this image with the imnoise built-in Matlab function. The goal of this task is to obtain, once again, the silhouette of all three letters. */



= MORPHOLOGICAL GRADIENTS, TOP-HAT AND BOTTOM-HAT

/* Exercise 4.
Provide examples of morphological gradients, top-hat and bottom-hat operations in both binary and gray scale images.  Explain their main properties and differences between each other. */

