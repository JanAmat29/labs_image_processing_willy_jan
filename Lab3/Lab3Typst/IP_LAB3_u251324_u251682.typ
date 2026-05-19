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

        [#text(size: 16pt, weight: "bold", fill: black)[Assignment Lab 3]],
      ),
    )
  },
)

#set text(font: "Computer Modern", size: 11pt, lang: "en", fill: black)
#set par(justify: true, leading: 0.85em)

#align(center)[
  #text(size: 24pt, weight: "bold")[Contrast, equalization and quantization]
]

#set heading(numbering: "1.")

#set text(size: 11pt)

= LINEAR CONTRAST CHANGES //Exercise 1

= NONLINEAR CONTRAST CHANGES //Exercise 2
/* Exercise 2a. Discuss briefly how you think the value of gamma (<1 or >1) affects the
light and dark levels of an image when performing a nonlinear contrast change.
*/

== Discussion of gamma's value

Gamma correction is a non-linear function that takes place in the mathematical architecture of an image and its function is to map intensities. It is computed after the original optical signal has been convolved with the lens's Point Spread Function (PSF), representing the actual light hitting the sensor, $g(K * O)$ in @MathArchImg. 
#set math.equation(numbering: "(1)")
$ u = Q \{ Pi g(K * O) + n \} $ <MathArchImg>

Answering to the question, if gamma is less than 1, the function will be concave, which means that dark tonalities are expanded and light tonalities are compressed, resulting in increased contrast in the shadows. On the other hand, if gamma is greater than 1, the function will be convex, which means that dark tonalities are compressed and light tonalities are exapanded. In this case, the result will be a decrease in shadow contrast, but an increase in highlight contrast. 

There are two examples that clearly explain this behaviour. The first one is to look at the graphical representation (@GammaCorrection) of the function with gamma greater than 1, where we can see how a light level input is expanded. This graphical representation of the gamma correction is given in the theoretical slides.

/*example of figure structure
#figure(image("Images/lena_result.png",width:30%), caption: "Resulting image after applying the filter",
    )<colab:lena_result>
*/

#figure(
  image("img/gamma_correction.png", width: 50%),
  caption: "Graphical representation of the gamma correction function with gamma > 1 for a light level input."
)<GammaCorrection>

The other example is to mathematically demonstrate how gamma correction alters image contrast, we use normalized pixel values (scaled from 0 to 1) and the following power-law equation:

$ V_"out" = V_"in"^gamma $ <gamma_eq>

If we consider a dark input pixel with an intensity of 20% ($V_"in" = 0.2$), which being less than 0.5 would be more darker than brighter and a gamma encoding value of $gamma = 0.5 < 1$ :

$ V_"out" = 0.2^0.5 approx 0.447 $

The output intensity is elevated to approximately 45%. Because a narrow range of dark input values (0 to 0.2) is mapped to a significantly wider range of output values (0 to 0.447), the dark tonalities are effectively expanded.

/*
Exercise 2b. Select an image with low contrast and apply nonlinear contrast change to
visualize the dark details of the image without decreasing too much the overall contrast
of the image. What value of gamma do you use?
*/

== Nonlinear contrast change on a low contrast image

For this section we will modify the constrast of the image "img/low_contrast.png" (@LowContrastImage) using the gamma correction function imadjust which allows you by adding a final argument, gamma, to perform nonlinear contrast changes.

#figure(
  image("img/low_contrast.png", width: 25%),
  caption: "Original low contrast image."
)<LowContrastImage>

After testing different values of gamma (@Test1Gamma) ploting the image and its histogram, we found that a value of would be in the range of 1.4 to 1.5, which is a value greater than 1, so the function will be convex and the dark tonalities will be compressed and light tonalities will be expanded. This way we can visualize the dark details of the image without decreasing too much the overall contrast of the image.

#figure(
  image("img/Test1Gamma_exercise2.1.png", width: 100%),
  caption: "Low contrast image after applying a nonlinear contrast change with gamma = [1.3, 2.2]."
)<Test1Gamma>

To be more precise, we analyzed ten values of gamma from 1.4 to 1.5 with a step of 0.01 and we found that the best value was 1.41.

#figure(
  image("img/Test2Gamma_exercise2.1.png", width: 100%),
  caption: "Low contrast image after applying a nonlinear contrast change with gamma = 1.41."
)<Test141Gamma>

For this particular parameter value, the main   of the dark pixels (which would include information about shadows such as hair and fabrics) is optimally placed between pixel intensities of 0.15 and 0.25. This ensures excellent contrast between the dark areas and the brighter areas while keeping the data sufficiently above the 0.0 minimum level. Increasing the value of gamma to 1.48 or 1.50 would place this particular peak too close to the 0.0 value and result in compression and crushing of blacks, which would mean destruction of any texture present.

The final comparision between the low contrast image and the final result would be the following figure (@FinalComparisonEx2.1).

#figure(
  image("img/FinalComparison_exercise2.1.png", width: 100%),
  caption: "Final comparison between the low contrast image and the gamma-corrected result."
)<FinalComparisonEx2.1>



