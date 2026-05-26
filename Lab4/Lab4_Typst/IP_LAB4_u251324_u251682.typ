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

To start with this exercise we are going to do a recap of the morphological operations we have seen in the lectures, and then we will apply them to the image of Evarist and Ermessenda.

== Linear filters

The operations we are going to use are also linear filters. They are based on the use of a structuring element, which is a small shape that is used to probe the image. The structuring element is moved across the image, and at each position, it is compared with the underlying pixels. Depending on the operation, the output pixel value is determined by the comparison between the structuring element and the underlying pixels. 

=== Dilation

#align(center)[
  #set math.equation(numbering: "(1)")
  $ delta_B(X) = X + B = {x + y : x in X, y in B} = union_(y in B) (X + y) $ <DilationFormula>
]

The first linear filter is dilation (@DilationFormula), which is used to grow the boundaries of objects in a binary image. The structuring element is moved across the image, and at each position, if any of the underlying pixels are 1 (white), the output pixel is set to 1. This operation can be used to fill small holes in objects or to connect nearby objects. In @DilationExample we can see the result of applying dilation to the image of Evarist and Ermessenda.

#figure(
  image("img/dilation_example.png", width: 55%),
  caption: "Dilation example."
)<DilationExample>

=== Erosion

#align(center)[
  #set math.equation(numbering: "(1)")
$ epsilon_B(X) = {x in X : x + B subset.eq X} = sect_(y in B) (X - y) $ <ErosionFormula>
]
//TODO - TAG EQUATION NUMBERING
The second linear filter is erosion (@ErosionFormula), which is used to shrink the boundaries of objects in a binary image. The structuring element is moved across the image, and at each position, if all of the underlying pixels are 1 (white), the output pixel is set to 1. This operation can be used to remove small objects or to separate connected objects. In @ErosionExample we can see the result of applying erosion to the image of Evarist and Ermessenda.

#figure(
  image("img/erosion_example.png", width: 50%),
  caption: "Erosion example."
)<ErosionExample>

*Here is where the things get interesting, because the following filters, might help us to solve the tasks of this exercise.*

=== Opening & No Holding Hands

#align(center)[
  #set math.equation(numbering: "(1)")
$ gamma_B(X) = delta_B(epsilon_B(X)) $ <OpeningFormula>
]

The third linear filter is opening (@OpeningFormula), which is a combination of erosion followed by dilation. This operation can be used to remove small objects or to separate connected objects while preserving the shape of larger objects. In @OpeningExample we can see the result of applying opening to the image of Evarist and Ermessenda. In this case, we can see that the hands of Evarist and Ermessenda are separated, but the rest of their bodies are preserved. This is because the opening operation removes small objects (the hands) while preserving larger objects (the bodies). In detail, the left arm of Evarist and both arms of Ermessenda are removed, the aim was simply to separate the hands, but the structuring element used for the opening operation was too large, which caused the removal of the arms as well. This is a common issue when using morphological operations, and it is important to choose the right structuring element size to achieve the desired result. After several trials, we found that a structuring element of size 5x5 and setting the number of iterations to 1 was the best option.

#figure(
  image("img/opening_example.png", width: 50%),
  caption: "Opening example."
)<OpeningExample>

=== Closing & Healing Holes

#align(center)[
  #set math.equation(numbering: "(1)")
$ phi_B(X) = epsilon_B(delta_B(X)) $ <ClosingFormula>
]

The fourth linear filter is closing (@ClosingFormula), which is a combination of dilation followed by erosion. This operation can be used to fill small holes in objects or to connect nearby objects while preserving the shape of larger objects. In @ClosingExample we can see the result of applying closing to the image of Evarist and Ermessenda. In this case, we can see that the holes in the bodies of Evarist and Ermessenda are filled, but the rest of their bodies are preserved. This is because the closing operation fills small holes (the holes in the bodies) while preserving larger objects (the bodies). In this task we got a better result that we did in the last one, and finding the right structuring element size was easier, we found that a structuring element of size 4x4 and setting the number of iterations to 1 was the best option.

#figure(
  image("img/closing_example.png", width: 50%),
  caption: "Closing example."
)<ClosingExample>

The exercise has not finished with this last filter because we still have to get the boundaries of the holding-hands couple. This goal will require the use of both dilation and erosion, but we will see how to combine them to get the desired residue.

== Residues

=== Centered Gradient & Boundary Extraction

/* The centered gradient of u is defined as the difference between the dilation
and the erosion of u by B, that is,
∇c
B(u) = δB(u)−ϵB(u).

Intuition: pixel changes relative to their local neighbourhood. Useful for edge
detection in greyscale images.

 */

#align(center)[
  #set math.equation(numbering: "(1)")
$ nabla^c_B(u) = delta_B(u) - epsilon_B(u) $ <CenteredGradientFormula>
]
 
The name of this filter (@CenteredGradientFormula) is quite self-explanatory, it is a gradient that is centered in the original image, and it is obtained by subtracting the erosion from the dilation. This operation can be used to edge detection in greyscale images. In @CenteredGradientExample we can see the result of applying the centered gradient to the image of Evarist and Ermessenda. For this result, we can see that the boundaries of Evarist and Ermessenda are preserved, but the rest of their bodies are extracted. The reason why this happens is because the centered gradient operation preserves the edges of objects while removing the interior pixels. This is because the dilation operation expands the boundaries of objects, while the erosion operation shrinks the boundaries of objects. When we subtract the erosion from the dilation, we are left with only the edges of objects, which is what we wanted to achieve in this task. An interesting observation out of this result is that the holes in the bodies of Evarist and Ermessenda are also preserved, this is because the dilation operation fills the holes, while the erosion operation removes the holes. When we subtract the erosion from the dilation, we are left with only the edges of objects, which includes the holes in this case. For this task we found that a structuring element of size 3x3 and setting the number of iterations to 1 was the best option.

#figure(
  image("img/centered_gradient_example.png", width: 50%),
  caption: "Centered gradient example."
)<CenteredGradientExample>

== Results

At the end of this exercise, @Ex1Results shows the final results of applying the morphological operations to the image of Evarist and Ermessenda. We can see that the hands of Evarist and Ermessenda are separated, the holes in their bodies are filled, and the boundaries of their bodies are preserved.

#figure(
  image("img/ex1_results.png", width: 100%),
  caption: "Exercise 1 results."
)<Ex1Results>



= SEGMENTATION OF LETTERS

/* Exercise 2.
Find a proper segmentation of the image letters.png separating the letters from the background. */



= SEGMENTATION OF NOISY LETTERS

/* Exercise 3.
Drawthree letters in a blank image with a any kind of Drawing software (Gimp or Paint work fine); introduce noise to this image with the imnoise built-in Matlab function. The goal of this task is to obtain, once again, the silhouette of all three letters. */



= MORPHOLOGICAL GRADIENTS, TOP-HAT AND BOTTOM-HAT

/* Exercise 4.
Provide examples of morphological gradients, top-hat and bottom-hat operations in both binary and gray scale images.  Explain their main properties and differences between each other. */

