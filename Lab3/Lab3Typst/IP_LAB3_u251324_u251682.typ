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
#show figure.caption: set text(size: 0.85em)

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

Answering to the question, if gamma is less than 1, the function will be concave, which means that dark tonalities are expanded and light tonalities are compressed, resulting in increased contrast in the shadows. On the other hand, if gamma is greater than 1, the function will be convex, which means that dark tonalities are compressed and light tonalities are exapanded. In this case, the result will be a decrease in shadow contrast, but an increase in highlight contrast. In @GammaGraph, we can see the graphical representation of the gamma correction function for both cases, where the x-axis represents the input light levels and the y-axis represents the output light levels after applying gamma correction. 

#figure(
  image("img/gamma_graph.png", width: 60%),
  caption: "Graphical representation of the gamma correction function for gamma < 1 (purple line) and gamma > 1 (yellow line)."
)<GammaGraph>

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

/* 
Exercise 3. Image Histogram Equalization
Exercise 3a. Display: (a) the histogram of an RGB image (R, G, B separate histograms),
and (b) the histogram of a grayscale image.
Exercise 3b. Implement a function to perform image equalization. Use it to equalize
several images. Display the result of equalization and compare the histograms of the
original images with the equalized ones

 */

= Image Histogram Equalization

== Display of Histograms

To display the histograms of a RGB and grayscale image we have chosen the images of "img/lena_color.png" and"img/lena.png" respectively (@LenaColorImage and @LenaGrayImage).

/*Example of grid structure
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 1em,
    [
        #figure(image("Images/filter_ai.png",width:100%), caption: "Ideal filter created by AI",
        )<colab:filter_ai>
    ],
      [
          #figure(image("Images/lena_freq_ai.png", width:100%), caption: "FFT of the noisy image with the ideal filter applied",
          )<colab:lena_freq_ai>
      ],
    [
        #figure(image("Images/lena_result_ai.png", width:100%), caption: "Resulting image after applying the ideal filter",
        )<colab:lena_result_ai>
    ],
)

 */

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

Thanks to the function `plt.hist(image.ravel(), bins = 256)` found in the given notebook's code, we can display the histograms of both images (@HistogramsRGB and @HistogramGray).

//There are only two histograms, one for the RGB image and one for the grayscale image, but the RGB histogram is separated into three channels, so we will display them separately in a grid.

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,

  [
    #figure(
      image("img/histogram_rgb.png", width: 100%),
      caption: "Histogram of the RGB image separated into R, G and B channels."
    )<HistogramsRGB>
  ],

  [
    #figure(
      image("img/histogram_gray.png", width: 100%),
      caption: "Histogram of the grayscale image."
    )<HistogramGray>
  ],
)

As is precised in the caption of @HistogramsRGB, the histogram of the RGB image is separated into R, G and B channels, where we can see that the red channel has a higher frequency of pixel intensities in the range of 100 to 200, while the green and blue channels have a more uniform distribution of pixel intensities. On the other hand, the histogram of the grayscale image shows a more uniform distribution of pixel intensities across the entire range from 0 to 255, with a slight peak around the intensity value of 128. This indicates that the grayscale image has a more balanced distribution of light and dark pixels compared to the RGB image.

== Image Equalization

By introducing the histogram equalization is a technique used to enhance the contrast of an image by redistributing the pixel intensity values. The goal is to achieve a more uniform distribution of pixel intensities across the entire range, which can help to reveal details that may be hidden in the original image.

To perform histogram equalization, we must remind that the formula to compute the new pixel intensity values is given by:

$ h(v) = "round"( ("cdf"(v) - "cdf"_"min") / (N - "cdf"_"min") times (L - 1) ) $ <HistogramEqualizationFormula>

Where $h(v)$ is the new pixel intensity value, $"cdf"(v)$ is the cumulative distribution function of the pixel intensity values, $"cdf"_"min"$ is the minimum value of the cumulative distribution function, $N$ is the total number of pixels in the image, and $L$ is the number of possible intensity levels (usually 256 for an 8-bit image).

Translating @HistogramEqualizationFormula into python code, we can implement the histogram equalization function as follows:

```python
import numpy as np
import matplotlib.pyplot as plt

def equalize_histogram(image):
        
    # 1. Calculate the histogram (256 bins for 8-bit image)
    hist, bins = np.histogram(image.flatten(), bins=256)

    # 2. Calculate the Cumulative Distribution Function (CDF)
    cdf = hist.cumsum()
    
    # The Equalization Formula
    L = 2**8  # Number of possible intensity levels (256)
    cdf = (cdf - cdf.min()) * (L - 1) / (cdf.max() - cdf.min())
```

After implementing the histogram equalization function, we can apply it to several images and compare the results. For example, we can apply it to the girl low contrast image (@LowContrastImage) and to more low contrast images found in the images folder like @GabeLowContrast and @HatLowContrast and then display the results along with their histograms.

// display gabe low contrast image and hat low contrast image

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,

  [
    #figure(
      image("img/gabe_low_contrast.jpg", width: 51%),
      caption: "Original low contrast image of Gabe."
    )<GabeLowContrast>
  ],

  [
    #figure(
      image("img/hat.jpg", width: 60%),
      caption: "Original low contrast image of a hat."
    )<HatLowContrast>
  ],
)

We will compare the histogram equalization results image by image. Starting with the girl we can see the comparision image in @GrilEqualResult, where we can see that the histogram equalization has enhanced the contrast of the image, making the details in the shadows and highlights more visible. The histogram of the equalized image shows a more uniform distribution of pixel intensities across the entire range compared to the original image, which had a more concentrated distribution of pixel intensities in the mid-range.

#figure(
  image("img/girl_equalized.png", width: 100%),
  caption: "Comparison between the original low contrast image of the girl and the histogram equalized image."
)<GrilEqualResult>

When it comes to the Gabe image, it is also possible to make a comparison using @GabeEqualResult. It is clear that, despite the equalization process taking place, the visual result achieved is not even close to being similar to the one obtained for the girl. Although the mathematical process caused the pixel intensities to be spread out all the way from zero to maximum, the visual outcome was not natural at all; on the contrary, it was very noisy.

The reason behind the failure of the equalization process in the Gabe case can be easily found in the histograms. The problem is that the original image contained very few pixels, which were clustered together in a tiny distribution. When trying to stretch this distribution across the whole spectrum of pixel intensities, it resulted in huge gaps between individual pixels in the histogram.

#figure(
  image("img/gabe_equalized.png", width: 100%),
  caption: "Comparison between the original low contrast image of Gabe and the histogram equalized image."
)<GabeEqualResult>

Finally, we analyze the woman dressing the hat, depicted in @HatEqualResult, which can be considered the most successful example of histogram equalization amongst all the images analyzed. It is a very realistic result, with detail like the freckles in the textures being clearly visible and well-preserved.

This is owed entirely to the intrinsic structure of pixel data in this particular image. Firstly, the image is formed almost entirely of dense, high-frequency textures such as the shapes of the face and the clothing, and does not contain any large areas of uniformly colored background. Consequently, its histogram does not feature the large spikes in pixel density that normally disrupt and distort the Cumulative Distribution Function (CDF).

As a result, the equalization algorithm is able to evenly stretch the compressed pixel densities across the whole dynamic range without introducing any quantization or clipping artifacts. Given that the underlying image data is sufficiently continuous and dense, there are no sudden discontinuities introduced into the histogram through the process of stretching.

#figure(
  image("img/hat_equalized.png", width: 100%),
  caption: "Comparison between the original low contrast image of the hat and the histogram equalized image."
)<HatEqualResult>

= Image Entroy

/*
Exercise 5. Quantization
Exercise 5a. Determine experimentally the smallest number (approximately) of levels
for which the quantization is unnoticeable for the eye.
Exercise 5b. Binarize an image using the attached uniform quantizer.m function.
*/

= Quantization

== Experimental smallest quantization levels

As is detailed in the statement of the exercise, experimentally we have evaluated Gray Lena image @LenaGrayImage with different levels of quantization, the function given in the notebook `uniform_quantizer(image, N)`, where `N` is the number of quantization levels, has helped to perform the quantization process. 

/*
CODE USED
import matplotlib.pyplot as plt

# 1. Ensure your instructor's function is defined
# (Paste the def uniform_quantizer... code here)

# 2. Run the Experiment to find the "unnoticeable" threshold
test_levels = [128, 64, 32, 16, 8, 4]

fig, axes = plt.subplots(2, 3, figsize=(15, 10))
axes = axes.flatten()

for i, levels in enumerate(test_levels):
    # USE YOUR NOTEBOOK'S FUNCTION HERE:
    q_img = uniform_quantizer(lena, levels)
    
    # Plot it
    axes[i].imshow(q_img, cmap='gray', vmin=0, vmax=255)
    axes[i].set_title(f"Quantized to {levels} Levels")
    axes[i].axis('off')

plt.tight_layout()
plt.show()
 */

We consider the following quantization levels: 128, 64, 32, 16, 8 and 4 in @TestQuantization. After applying the quantization, we can visually analyze that from this quantization levels, the smallest that is unnoticeable is 32 levels. 16 levels already shows a significant loss of detail, mostly on the background, while 32 levels still retains most of the visual information and details without introducing significant artifacts. Therefore, we can conclude that the smallest number of quantization levels for which the quantization is unnoticeable for the eye is approximately 32 levels.

#figure(
  image("img/test_quantization.png", width: 100%),
  caption: "Quantization of the grayscale Lena image with different levels of quantization."
)<TestQuantization>

== Binarization of an image

To binarize an image, we can use the `uniform_quantizer` function with `N=2`, which will quantize the image into two levels: 0 and 255. This effectively creates a binary image where pixels are either black (0) or white (255) based on a threshold determined by the quantization process. For example, if we apply this to the grayscale Lena image (@LenaGrayImage), we can obtain the binarized version of the image (@BinarizedLena).

#figure(
  image("img/binarized_lena.png", width: 100%),
  caption: "Binarized version of the grayscale Lena image using uniform quantization with N=2."
)<BinarizedLena>

= Quantization

= Quantitative Criteria of Fidelity

= Halftoning


















