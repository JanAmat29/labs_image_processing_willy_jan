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

The second exercise requires addressing an issue that plagues many image-processing tasks: separating hand-written text from a heavily shadowed image background. Looking at the original image below, one can see the dramatic change of illumination from left to right – ranging from darkness to brightness. Consequently, applying global threshold to such image would yield bad results: what works well for the bright area would make everything to the left black. In order to overcome this problem, we need to employ mathematical morphology and find a way to remove the background.

== Background Estimation via Closing

Since the text is strictly darker than the background (paper), we can use the morphological closing operation to eliminate the text and isolate the illumination gradient. 

#align(center)[
  #set math.equation(numbering: "(1)")
  $ phi_B(X) = epsilon_B(delta_B(X)) $ <Ex2ClosingFormula>
]

The closing operator (@Ex2ClosingFormula), which applies a dilation operation followed by an erosion operation, suits this application best. Using a structuring element $B$ (as implemented in our code, a 15x15 pixel square kernel) that is bigger than the stroke width of the letters and smaller than the spaces between the text lines, we can control how the image features will behave.

Since the letters themselves are black, the first operation of dilation results in shrinking the ink region to nothing at all. The following erosion process brings back the original boundaries of the now completely white text regions. In the end, we obtain (@ClosingBackground) an even image with *just* the shadow gradients left.

#figure(
  image("img/closing_background.png", width: 60%),
  caption: "Background estimation using morphological closing."
)<ClosingBackground>

== Illumination Correction and Binarization

Once we have an accurate mathematical estimation of the background, we can correct the uneven lighting in the original image.

=== Subtraction (Uniform Illumination)

Through subtraction of the original image from the background we estimate, we will achieve flattening of the illumination throughout the entire image. Mathematically, subtraction of the background from itself will yield a value close to black (zero), whereas subtraction of the dark ink from the brightly colored background will give a positive result (bright). This technique works well in isolating the ink, giving us bright ink on a dark background. The resulting image (@Subtracted) is now uniformly illuminated, with the text clearly standing out against a dark background.

#figure(
  image("img/subtracted.png", width: 60%),
  caption: "Image after background subtraction, showing uniform illumination."
)<Subtracted>

=== Thresholding and Inversion

Because the illumination is now perfectly uniform across the entire document, we no longer need complex adaptive algorithms. A simple, hard-coded global binarization (using a low threshold like 0 or 15) successfully separates the text from the flattened background. Finally, to restore the natural appearance of the document (dark text on a light background), we apply a bitwise inversion to flip the colors of the segmented mask. The final result (@FinalSegmented) is a clean, high-contrast binary image.

#figure(
  image("img/final_segmented.png", width: 60%),
  caption: "Final segmented text after thresholding and inversion."
)<FinalSegmented>

== Results

The image @Ex2Results reveals the entire process performed by the program. In the upper left is the original image along with its heavy gradient. The image on the upper right is the isolated background that has been computed using the closing operation. The one in the lower left is the even illumination after performing the subtraction.

#figure(
  image("img/ex2_pipeline.png", width: 65%),
  caption: "Exercise 2 pipeline: Original, Background Estimation (Closing), Subtraction, and Final Segmentation."
)<Ex2Results>


= SEGMENTATION OF NOISY LETTERS

In this exercise, the goal is to start from a hand-drawn image containing three letters, corrupt it with artificial noise, and then recover the silhouette of the letters using mathematical morphology. In our case, the image contains the letters "A", "B", and "C" drawn manually on a white background.

It is important to mention that the original letters are not fully filled. They are mainly drawn as outlines. This directly affects the final result: the algorithm preserves the geometric structure of the input image, so the recovered silhouette and final contour also keep this outline-like appearance instead of becoming solid filled letters.

== Original Image

The first image, shown in @Ex3Original, is the original hand-drawn input. It contains three letters over a bright background. The relevant information in this image is the geometry of the letters rather than the exact intensity values of the pixels.

Since the letters were drawn manually, their strokes are not perfectly uniform. Some parts are darker than others, and the contours are slightly irregular. This makes the problem more realistic than using computer-generated text, because the segmentation algorithm has to work with an imperfect input image.

#figure(
  image("img/IMG_ORIGINAL.png", width: 55%),
  caption: "Original hand-drawn image containing the three letters."
)<Ex3Original>

== Noise Addition

The second image, shown in @Ex3Noisy, corresponds to the same input after adding salt-and-pepper noise. This type of noise randomly changes some pixels to very dark or very bright values. As a result, many small noisy points appear both in the background and around the strokes of the letters.

The purpose of this step is to simulate a degraded image acquisition process. After adding noise, the image becomes harder to segment, because some noisy pixels have intensity values similar to the letter strokes. Therefore, a later cleaning stage is needed.

In our implementation, salt-and-pepper noise was added with an amount of 0.20. This introduces a visible amount of corruption while still preserving the main structure of the letters.

#figure(
  image("img/IMG_RUIDO.png", width: 55%),
  caption: "Image after adding salt-and-pepper noise."
)<Ex3Noisy>

== Binarization

The third image, shown in @Ex3Binarized, is the result of applying thresholding to the noisy image. Binarization converts the grayscale image into a binary mask, where each pixel is classified either as foreground or background.

In this case, the letters are darker than the background, so pixels below the selected threshold are classified as part of the letters. The threshold was computed automatically using Otsu's method, which searches for an intensity value that separates the image into two main classes.

However, the binarized image still contains noise. Some isolated pixels are incorrectly classified as foreground because the salt-and-pepper noise introduces dark points in the background. This explains why thresholding alone is not enough to obtain a clean result.

#figure(
  image("img/IMG_BINARIA.png", width: 55%),
  caption: "Binarized image obtained after thresholding the noisy input."
)<Ex3Binarized>

== Morphological Cleaning

After binarization, morphological operations are applied to clean the binary mask. First, small connected components are removed. These small components usually correspond to isolated noise pixels that do not belong to the actual letters.

Then, small holes are filled to make the detected regions more coherent. Finally, opening and closing operations are applied.

#align(center)[
  #set math.equation(numbering: "(1)")
  $ gamma_B(X) = delta_B(epsilon_B(X)) $ <Ex3OpeningFormula>
]

The opening operation (@Ex3OpeningFormula) consists of an erosion followed by a dilation. It is useful for removing small foreground artifacts while preserving larger structures.

#align(center)[
  #set math.equation(numbering: "(1)")
  $ phi_B(X) = epsilon_B(delta_B(X)) $ <Ex3ClosingFormula>
]

The closing operation (@Ex3ClosingFormula) consists of a dilation followed by an erosion. It helps to close small gaps and connect nearby regions that should belong to the same object.

The result of this cleaning process is shown in @Ex3Clean. Most of the random noise has disappeared, while the main shape of the three letters has been preserved. Since the original letters were drawn as outlines, the cleaned silhouette also keeps this hollow structure.

#figure(
  image("img/IMG_SILUETA_LIMPIA.png", width: 55%),
  caption: "Cleaned silhouette after removing small objects, filling holes, and applying opening and closing."
)<Ex3Clean>

== Final Contour Extraction

The final step consists of extracting the contour of the cleaned letters. This is done using a morphological boundary operation based on dilation and erosion.

#align(center)[
  #set math.equation(numbering: "(1)")
  $ partial X = delta_B(X) - epsilon_B(X) $ <Ex3BoundaryFormula>
]

The idea behind @Ex3BoundaryFormula is that dilation slightly expands the foreground regions, while erosion slightly shrinks them. The difference between both results highlights the pixels located near the boundary of the objects.

The final contour is shown in @Ex3Contour. The letters are clearly detected, and their boundaries are visible. Since the original letters were hollow outlines, the final contour contains both the external and internal borders of the strokes. This is not an error, but the expected behaviour for this type of input image.

#figure(
  image("img/IMG_CONTORNO_FINAL.png", width: 55%),
  caption: "Final contour extracted from the cleaned binary mask."
)<Ex3Contour>

== Results

The complete process shows how mathematical morphology can recover useful geometric information from a noisy image. Starting from a hand-drawn input, noise was added, the image was binarized, and several morphological operations were applied to remove artifacts and preserve the shape of the letters.

The final result successfully detects the three letters and extracts their contours. The fact that the contour appears as a double outline is a consequence of the original drawing: the letters were drawn as outlines rather than as filled solid shapes. If the original letters had been filled in black, the cleaned silhouette would have appeared as solid letters and the final contour would mainly represent their external boundary.




= MORPHOLOGICAL GRADIENTS, TOP-HAT AND BOTTOM-HAT

/* Exercise 4.
Provide examples of morphological gradients, top-hat and bottom-hat operations in both binary and gray scale images.  Explain their main properties and differences between each other. */

