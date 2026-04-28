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

        [#image("Images/UPFt_rgb.png", width: 50%)],

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

        [#text(size: 16pt, weight: "bold", fill: black)[Assignment Lab 2]],
      ),
    )
  },
)

#set text(font: "Computer Modern", size: 11pt, lang: "en", fill: black)
#set par(justify: true, leading: 0.85em)

#align(center)[
  #text(size: 24pt, weight: "bold")[Fourier and applications]
]

#set heading(numbering: "1.")

#set text(size: 11pt)


= REMOVE NOISE TO LENA

== Introduction

//Open the image lena_noisy.png in the working directory. Write a program that removes the noise and recovers the original clear image. Show the resulting image in the Fourier domain as well.

In this exercise, we are asked to remove the noise from the image "lena_noisy.png" (@labs:lena_noisy) and make it look like the original photo "lena.png" (@labs:lena) after applying this transformation.

#grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
        #figure(image("Images/lena_noisy.png",width:60%), caption: "Image of Lena with the noise",
    )<labs:lena_noisy>
    ],
    [
        #figure(image("Images/lena.png", width:60%), caption: "Image of Lena with the noise",
    )<labs:lena>
    ],
)

== First intuition

Our first thought was to match the noise seen in the Lena image with an example explained in the theory (@theory:spatial_noise). The noise from the theory class had a similar shape, appearing as a black and white wave. The theory included a plot of this noise in the frequency domain (@theory:frequency_noise), which could simply be described as two dots specifying the frequency values of the noise. So, our first hypothesis was that the aim of the exercise was to find the dots in the frequency domain of @labs:lena_noisy and then apply a filter to remove them, hoping this would achieve the goal of the exercise.

#grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
        #figure(image("Images/theory_noise_spatial.png",width:60%), caption: "Example of noise explained in the theories",
    )<theory:spatial_noise>
    ],
    [
        #figure(image("Images/theory_noise_frequency.png", width:60%), caption: "Frequency domain of Figure 3",
    )<theory:frequency_noise>
    ],
)

== First look at our image

To confirm that we were right we applied a FFT (Fast Fourier Transform) to @labs:lena_noisy (@colab:lena_noisy_freq) specting that the result would have the same frequency domain as @labs:lena_noisy (@colab:lena_freq) but with two dots representing the noise.

#grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
        #figure(image("Images/lena_noisy_freq.png",width:50%), caption: "FFT of the noisy Lena image",
    )<colab:lena_noisy_freq>
    ],
    [
        #figure(image("Images/lena_freq.png", width:50%), caption: "FFT of the original Lena image",
    )<colab:lena_freq>
    ],
)

As we can see, the result is exactly as we expected. Now thw next step would be remove this two dots from the frequency domain of @labs:lena_noisy and then apply an inverse FFT to get the resulting image.

== First intuition of the filter

Taking into account where were places the two dots of @colab:lena_noisy_freq we thought that the proper filter explained in the theory should be the BPF (Band Pass Filter). The dots were representing a low frequency respect to some other that could be seen in the original image, but they were not even close the lowest ones. So applying a combination of filters that remove lower or equal frequencies as the frequencies of the dots was a bad idea, because we would be removing a lot of frequencies that are not noise. And the image could be too blurry. On the other hand, applying a BPF that only remove frequencies around the ones of the dots would be a good idea, because we would be removing only the noise and not the rest of the frequencies.

== Creation of the filter

To create the filter was really helpful to learn from the filter examples in the Colab NoteBook. After analyzing some of them we decided that our filter should the sum of a LPF and HPF. In this way, the plot result of the filter should be at most white, but it should have a black circle in the middle representing the frequencies that we want to remove. The rest of the frequencies should be white, because we want to keep them. With the example filters we did a first plot representing the first idea we had for the filter (@colab:filter_idea).

We had a lot of trubble to find the right values for the radius of the circles of the LPF and HPF, but after some trial and error we found that a radius of 20 pixels for the LPF and 21.3 pixels for the HPF were strictly the right values to remove the noise without removing too much frequencies. The resulting filter can be seen in @colab:filter_result.

#grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
        #figure(image("Images/filter_idea.png",width:50%), caption: "First idea of the filter",
    )<colab:filter_idea>
    ],
    [
        #figure(image("Images/filter_result.png", width:50%), caption: "Resulting filter",
    )<colab:filter_result>
    ],
)

== Application of the filter

After creating the filter, we applied it to the FFT of @labs:lena_noisy and then we applied an inverse FFT to get the resulting image. The resulting image can be seen in @colab:lena_result. As we can see, the resulting image is really similar to the original Lena image, but it is not exactly the same. We can see that there is still some noise in the resulting image, but it is really reduced compared to the original noisy image. We think that the reason why there is still some noise in the resulting image is because the combination of the two filters is not perfect, due to its circular shape. The ideal filter should be two circles with the same radius as the dots and centered in the same position as the dots. But with the resources given in the theoretical and practical classes, we consider we were not able to create a filter with this shape, so we had to settle for a combination of two filters that was not perfect, but it was good enough to remove most of the noise.

#figure(image("Images/lena_result.png",width:30%), caption: "Resulting image after applying the filter",
    )<colab:lena_result>


== Extra: Asking AI for the perfect filter

To understand well how our ideal filter would be implemented, we asked to an AI to create a filter that would remove the noise from the image. AI talked about a Notch Filter which was not in the theory classes but had the exactly shape we thought it would have. The resulting filter can be seen in @colab:filter_ai. It is interesting to see the plot of the filter applied in the frequency domain of the noisy image (@colab:lena_freq_ai). And finally we can observe that the final result it is almost perfect and can be seen in @colab:lena_result_ai. The only downside is that the lines and they can still be slightly detected.

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


= SUBSAMPLING AND ALIASING

== Introduction

In this exercise, we study what happens when an image with thin patterns is subsampled. We used the image of the striped pants (@labs:pantalons), because the stripes are a good example of high frequency content. The exercise consists in reducing the image by different factors and comparing the result with and without pre-processing.

#figure(image("Images/pantalons.jpg", width:30%), caption: "Original image used for the subsampling exercise",
)<labs:pantalons>

== Pre-processing to avoid aliasing after subsampling

Before shrinking the image, we applied a low-pass filtering step. This is necessary because the image contains many small details, especially the stripes on the pants, and these details correspond to high frequencies. From the theory, we know that aliasing often appears in images with this kind of content, for example brick walls, striped clothes, or repetitive textures.

When the image is made smaller without any previous filtering, these high frequencies cannot be represented correctly in the reduced image. As a consequence, they appear as strange patterns or distorted textures. For this reason, the image has to be smoothed before subsampling. This reduces or removes the frequencies that would not fit correctly in the smaller image. In our case, this low-pass filtering step helps the stripes of the pants look more stable after subsampling.

== Pre-processing for factor 2 and factor 4

For subsampling by a factor of 2, we used a smoothing filter before taking every other pixel. In our case, we applied a 3x3 average filter. This works because the reduction is not too strong. The image loses some detail, but a light blur is enough to remove many of the high frequencies that would cause aliasing.

The theory explains subsampling of order 2 as keeping samples such as $f_(2k)$. In the Fourier domain, this operation combines coefficients from different frequency regions. This is the reason why filtering is needed before reducing the image: if the high frequencies are not removed first, they can be mixed with lower frequencies and create aliasing artifacts.

For subsampling by a factor of 4, the filtering has to be stronger. The image is reduced much more, so more high-frequency information must be removed before applying the subsampling. In this case, we used a 5x5 average filter. The result is more blurred than with a factor of 2, but this is expected. The purpose of the filter is to remove details that would later become aliasing artifacts. In general, the larger the subsampling factor, the stronger the low-pass filtering has to be.

== Ringing

In our results, ringing does not appear clearly. Ringing is related to the Gibbs phenomenon, which appears as oscillations around sharp discontinuities. In images, it can be seen as bands or ripples near edges, especially when high frequencies are removed too abruptly.

In this experiment, we used an average filter in the spatial domain, not an ideal sharp cut-off filter in the Fourier domain. Because of that, the ringing effect is not very noticeable. If ringing appeared, it could be reduced by using smoother filters, for example a Gaussian filter, instead of using a very abrupt binary mask in the Fourier domain. The lab material also explains that binary masks can produce ringing because they are not smooth, while Gaussian masks reduce this effect better.



