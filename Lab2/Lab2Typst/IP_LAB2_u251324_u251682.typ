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

#figure(image("Images/Subsampling_factor2_4_8.png", width:70%), caption: "Result of subsampling the image of the pants without pre-processing",
    )<colab:pantalons_subsampled_no_filter>

#figure(image("Images/Subsampling_afetr_filtering_factor2_4_8_filtered.png", width:70%), caption: "Result of subsampling the image of the pants with pre-processing",
    )<colab:pantalons_subsampled_filtered>
== Pre-processing for factor 2 and factor 4

For subsampling by a factor of 2, we used a smoothing filter before taking every other pixel. In our case, we applied a 3x3 average filter. This works because the reduction is not too strong. The image loses some detail, but a light blur is enough to remove many of the high frequencies that would cause aliasing.

The theory explains subsampling of order 2 as keeping samples such as $f_(2k)$. In the Fourier domain, this operation combines coefficients from different frequency regions. This is the reason why filtering is needed before reducing the image: if the high frequencies are not removed first, they can be mixed with lower frequencies and create aliasing artifacts.

For subsampling by a factor of 4, the filtering has to be stronger. The image is reduced much more, so more high-frequency information must be removed before applying the subsampling. In this case, we used a 5x5 average filter. The result is more blurred than with a factor of 2, but this is expected. The purpose of the filter is to remove details that would later become aliasing artifacts. In general, the larger the subsampling factor, the stronger the low-pass filtering has to be.

#figure(image("Images/comparison_factor2_factor2filtered.png", width:70%), caption: "Result of subsampling the image of the pants with pre-processing for factor 2 and factor 4",
    )<colab:pantalons_subsampled_filtered_2_4>

#figure(image("Images/comparison_factor4_factor4filtered.png", width:70%), caption: "Result of subsampling the image of the pants with pre-processing for factor 2 and factor 4",
    )<colab:pantalons_subsampled_filtered_4>

== Ringing

In our results, ringing does not appear clearly. Ringing is related to the Gibbs phenomenon, which appears as oscillations around sharp discontinuities. In images, it can be seen as bands or ripples near edges, especially when high frequencies are removed too abruptly.

In this experiment, we used an average filter in the spatial domain, not an ideal sharp cut-off filter in the Fourier domain. Because of that, the ringing effect is not very noticeable. If ringing appeared, it could be reduced by using smoother filters, for example a Gaussian filter, instead of using a very abrupt binary mask in the Fourier domain. The lab material also explains that binary masks can produce ringing because they are not smooth, while Gaussian masks reduce this effect better.


= SUB-PIXEL TRANSLATION

== Introduction

In this exercise, we worked with two simple one-dimensional signals and translated them to the right. The first signal, $x$, is a step-like signal where the first values are 0 and the last values are 1. The second signal, $y$, is more like an impulse, because it only has one value equal to 1 and the rest are 0. These two examples are useful because it is easy to see what happens when the signal is shifted.

The main point of the exercise is not only to translate the signal by an integer number of pixels, but also to understand what happens when the translation is smaller than one pixel. This is called a sub-pixel translation. In that case, the values cannot simply be moved from one position of the array to another, because there is no exact array index for a displacement like 0.5 or 0.1 pixels.

#figure(image("Images/Original_x.png", width:50%), caption: "Signals used for the translation exercise",
    )<colab:signals>
#figure(image("Images/Original_y.png", width:50%), caption: "Signals used for the translation exercise",
    )<colab:signals>
== Translation using the Fourier shift theorem

To do the translation, we used the Fourier shift theorem. The idea is that instead of moving the samples directly in the spatial domain, we transform the signal to the frequency domain using the FFT. Then we multiply the Fourier coefficients by a phase factor that depends on the translation distance. Finally, we apply the inverse FFT to return to the spatial domain.

This method is useful because it allows translations by non-integer values. If we tried to translate the signal directly in the array, we could only move it by complete positions, for example 1 pixel or 2 pixels. But using the Fourier domain, a displacement of 0.5 pixels or 0.1 pixels can also be represented.

In our implementation, a positive value of the displacement moves the signal to the right. After applying the inverse FFT, the result can contain small decimal values, and sometimes very small numerical errors. These errors are expected because the computation is done with floating point numbers.

== Translation by 0.5 pixels

When the signal is translated by 0.5 pixels, the result is no longer made only of 0s and 1s. The values are distributed between neighbouring positions. This makes sense because the signal has been moved half way between two samples, so the new signal cannot be represented as a simple copy of the original one.

For the signal $x$, the transition between 0 and 1 becomes smoother and spreads around the original edge. For the signal $y$, the single impulse is also spread into several values instead of staying as a single value equal to 1. This is one of the clearest effects of sub-pixel translation: the signal keeps the same general structure, but the energy is shared between nearby samples.

Then we repeated the displacement of 0.5 pixels twice. Since $0.5 + 0.5 = 1$, the final result should be equivalent to translating the signal by one complete pixel to the right. In the results, this is what we observe. The intermediate result after the first translation contains fractional values, but after the second translation the signal is much closer to an integer-pixel shift.

#figure(image("Images/x_translated_0.5.png", width:70%), caption: "Result of translating the signals by 0.5 pixels",
    )<colab:translation_05>

#figure(image("Images/y_translated_0.5.png", width:70%), caption: "Result of translating the signals by 0.5 pixels twice",
    )<colab:translation_05_twice>

== Translation by 0.1 pixels

We also repeated the same experiment with a smaller displacement of 0.1 pixels. In this case, the changes after a single translation are more subtle. The signal is only moved by a very small amount, so the shape changes less than with the 0.5 pixel translation.

However, when the 0.1 pixel displacement is applied ten times, the total displacement is again one full pixel. The interesting part here is that we can see the signal moving little by little at each step. Each intermediate result is slightly different from the previous one, and after ten repetitions the final result is approximately the same as applying a translation of 1 pixel.

This also shows that small sub-pixel translations can accumulate. Even if one step of 0.1 pixels seems almost invisible, repeating it several times produces a clear displacement.

#figure(image("Images/x_and_y_translated_0.1.png", width:70%), caption: "Result of translating the signals by 0.1 pixels",
    )<colab:translation_01>

== Interpretation

The results show that integer translations and sub-pixel translations behave differently. With an integer translation, the signal is basically moved from one sample position to another. With a sub-pixel translation, the signal has to be reconstructed between samples, so the output contains intermediate values.

This is especially visible in the signal $y$, because a single impulse cannot be moved half a sample without spreading its value around. The same idea applies to images: when an image is translated by a non-integer number of pixels, the new pixel values have to be estimated from neighbouring pixels. For this reason, sub-pixel transformations usually create smoother transitions and decimal values.

In conclusion, the Fourier shift theorem lets us translate signals by fractional distances without using a simple rounded shift. Applying 0.5 pixels twice or 0.1 pixels ten times gives approximately a 1-pixel displacement, although small numerical differences can appear because of floating point precision.


= ANALYSIS OF IMAGE ROTATION

//Implement a precise shear operator, which performs the following affine transformation of the domain of an image: (x, y)→ (x+ay,y) where a is any real number. Once done, you can implement the method of Yaroslavski to rotate an image (pages 80 81 of the notes or exercise 8 of the Seminar 3). According to this method, a rotation is expressed as the product of three shears. Having obtained the appropriate translations for a an angle equal to pi/2 radians, compare the results of this method with the naıve methods for rotations (rotate and interpolate pixel values) or using a drawing program (paint or similar).

== Introduction

Once read the statement of the execise we observe familiar topics that were explained in the theory lessons. The first part of the exercise asks us to implement a shear operator, described by the transformation (x, y)→ (x+ay,y). This is a type of affine transformation that shifts the x-coordinate of each pixel by an amount proportional to its y-coordinate. The second part of the exercise asks us to implement Yaroslavski's method for rotating an image, which expresses a rotation as a product of three shear operations. 

== Shear operator

To implement the shear operator we could simply shift each row by the fractional amount given by the parameter a. But the problem here is that we would get a blurry image and a lost in the high frequencies. The reason for that is that this method requires interpolating pixel values, which is not ideal for this kind of transformation. Instead, as the most of the cases in the transformation of images, it is better to apply the transformation in the Fourier domain. In this case, we can take into account the Fourier Shift Theorem, which states that a shift in the spatial domain corresponds to a multiplying it by a linear phase factor in the frequency domain. The process would be:

+ Apply FFT to convert the image to the frequency domain
+ Multiply each frequency component $u$ of row $y$ by the phase shift  $e^("j"2pi"u"·(a · y) / N)$ 
+ Apply the 1D Inverse FFT (IFFT) to get the perfectly shifted row back in the spatial domain.

It will be easier to understand this second method if we plot the spatial domain for a simple image, for example for @labs:pantalons. In the next section we will see that for applying the Yaroslavski's method we will need to apply the shear operator three times, where two of them will be an horizontal shear and the other one will be a vertical shear. So, for the horizontal shears we will apply the method explained above, and for the vertical shear we will apply the same method but shifting columns instead of rows. In @colab:shear_horizontal_example we can see the result of applying the horizontal shear operator to the image of the pants with a value of a equal to 0.4. And in @colab:shear_vertical_example we can see the result of applying the vertical shear operator to the image of the pants with a value of a equal to 0.4.

#grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
        #figure(image("Images/shear_horizontal_example.png",width:50%), caption: "Horizontal shear operator applied to the image of the pants with a value of a equal to 0.4",
    )<colab:shear_horizontal_example>
    ],
    [
        #figure(image("Images/shear_vertical_example.png", width:50%), caption: "Vertical shear operator applied to the image of the pants with a value of a equal to 0.4",
    )<colab:shear_vertical_example>
    ],
)

== Yaroslavski's method for rotation

A standard 2D rotation matrix requires calculating new $(x,y)$ coordinates for every pixel, which demands computationally heavy and lossy 2D interpolation. Yaroslavski's method decomposes a rotation into three shear operations, which can be implemented more efficiently. The steps for a rotation by an angle $theta$ are:
1. Shear horizontally by $a = -tan(theta/2)$
2. Shear vertically by $b = sin(theta)$
3. Shear horizontally again by $c = -tan(theta/2)$

For a rotation of $pi/2$ radians, the values of the shears would be: a = -tan(pi/4) = -1 b = sin(pi/2) = 1 c = -tan(pi/4) = -1.

Applying these three shears in sequence will rotate the image by 90 degrees. The advantage of this method is that each shear can be implemented using 1D interpolation, which is computationally more efficient than 2D interpolation required for a direct rotation. After applying Yaroslavski's method, we can compare the result with a naive rotation method that directly calculates the new coordinates for each pixel and uses 2D interpolation, or with a rotation done using a drawing program. The results should be similar, but Yaroslavski's method should be more efficient and may produce less blurring due to the use of 1D interpolation. 

== Results

For the last part of the exercise, we applied Yaroslavski's method to rotate the image of the pants by 90 degrees. The resulting image can be seen in @colab:rotation_result. We also applied a naive rotation method that directly calculates the new coordinates for each pixel and uses 2D interpolation, and the result can be seen in @colab:naive_rotation_result.

#grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
        #figure(image("Images/rotation_result.png",width:50%), caption: "Yaroslavski's method of rotating the image of the pants by 90 degrees",
    )<colab:rotation_result>
    ],
    [
        #figure(image("Images/naive_rotation_result.png", width:50%), caption: "Naive rotation of the image of the pants by 90 degrees",
    )<colab:naive_rotation_result>
    ],
)

At first we can not notice any difference between the two resulting images, that is because only one rotation is not sufficietly to see the difference. So we applied the same rotation fifty times in a row, for an angle of 360/50 = 7.2 degrees that would result in a full rotation. The resulting images can be seen in @colab:rotation_result_50 and @colab:naive_rotation_result_50.

#grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
        #figure(image("Images/rotation_result_50.png",width:50%), caption: "Yaroslavski's method of rotating the pants by 7.2 degrees fifty times in a row",
    )<colab:rotation_result_50>
    ],
    [
        #figure(image("Images/naive_rotation_result_50.png", width:50%), caption: "Naive rotation of the pants by 7.2 degrees fifty times in a row",
    )<colab:naive_rotation_result_50>
    ],
)

Now we can see that the resulting image of Yaroslavski's method is really similar to the original image, while the resulting image of the naive rotation method is really blurry and it is hard to recognize the original image. Hence, we can conclude that Yaroslavski's method is more efficient and produces less blurring than the naive rotation method, especially when applying multiple rotations in sequence.