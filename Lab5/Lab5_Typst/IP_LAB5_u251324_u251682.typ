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
  #text(size: 24pt, weight: "bold")[Texture synthesis]
]

#set heading(numbering: "1.")

#set text(size: 11pt)

// 1. Define the style for inline raw text
#show raw.where(block: false): it => box(
  fill: rgb("#faeded"), // Light pink/red background color
  inset: (x: 3pt, y: 0pt), // Padding inside the box
  outset: (y: 3pt),
  radius: 2pt, // Rounded corners
  text(fill: rgb("000000"), it) // Ensures the text itself is black
)

// 2. Use standard backticks in your text
The python functions are `highlighted`.

/*
#figure(
  image("img/dilation_example.png", width: 55%),
  caption: "Dilation example."
)<DilationExample>
*/

/*
1 Modulus and phase of the DFT of an image
Figure 1: Left: image u1 (roma.png). Right: image u2 (texture.png).
Given two images u1 and u2 (Fig. 1) and their discrete Fourier transform ˆu1
and ˆu2 generate two new images v1 and v2 whose discrete Fourier transform are
defined as follows:
ˆ
v1 = |ˆu1|eiarg(ˆu2)
and
ˆ
v2 = |ˆu2|eiarg(ˆu1).
(1)
(2)
Here |ˆui|, i = 1,2 is the modulus of the discrete Fourier transform of ui, i = 1,2
and arg(ˆui), i = 1,2 is the phase of the discrete Fourier transform of ui, i = 1,2.
a) Create a Python code to compute v and v .
b) Comment and explain the results you obtained.
*/

= MODULUS AND PHASE OF THE DFT OF AN IMAGE

In this first exercise we are going to explore the modulus and phase of the DFT of an image. Given two images $hat(u)_1$ and $hat(u)_2$ (@ImgRoma and @ImgTexture) and their discrete Fourier transform $hat(u)_1$ and $hat(u)_2$ we are going to generate two new images $hat(v)_1$ and $hat(v)_2$ whose discrete Fourier transform are defined as follows in (@ModCarPhaseText) and (@ModTextPhaseCar).

#align(center)[
#set math.equation(numbering: "(1)")
$ hat(v)_1 = |hat(u)_1| e^(i "arg"(hat(u)_2)) $ <ModCarPhaseText>

$ hat(v)_2 = |hat(u)_2| e^(i arg(hat(u)_1)) $ <ModTextPhaseCar>

]

#grid(
  columns: (1fr, 1fr),
  gutter: 0.9em,

  [#figure(
    image("img/roma.png", width: 50%),
    caption: "Image u1 (roma.png)."
  ) <ImgRoma>],

  [#figure(
    image("img/texture.png", width: 50%),
    caption: "Image u2 (texture.png)."
  ) <ImgTexture>],
)

== Creation of $bold(hat(v)_1)$ (Modulus of $bold(hat(u)_1)$ and phase of $bold(hat(u)_2)$)

The procediment to create $hat(v)_1$ starts by computing the DFT of the input images $hat(u)_1$ and $hat(u)_2$ (_ `fft2()`_). Then we compute the modulus of $hat(u)_1$ (_ `np.abs()`_) and the phase of $hat(u)_2$ (_ `np.angle()`_) and we combine them to create $hat(v)_1$ as defined in (@ModCarPhaseText) (_ `modCar * np.exp(1j * phaseTexture)`_ ). Finally, we compute the inverse DFT of $hat(v)_1$ to obtain the synthesized image $v_1$ seen in @ModCarPhaseImage.

#figure(
  image("img/ModCarPhase.png", width: 30%),
  caption: "Image v1 (modulus of hat(u)_1 and phase of hat(u)_2)."
) <ModCarPhaseImage>

@ModCarPhaseImage shows that the synthesized image $hat(v)_1$ has the structure of the image $hat(u)_2$ (texture.png) but with the intensity values of the image $hat(u)_1$ (roma.png). This is because the phase of the DFT contains the structural information of the image, while the modulus contains the intensity information. For this case, as the geometry of the image $hat(u)_2$ does not follow a clear structure, it is difficult to identify similar shapes of the image $hat(u)_2$ in the synthesized image $hat(v)_1$. Moreover, in realistic cases, we would not be interested to create an image with the intensity values of $hat(u)_1$, due to is not a texture image that creates a aesthetic result. However, knowing the properties of the DFT allows us to understand how the phase and modulus contribute to the final synthesized image.

== Creation of $bold(hat(v)_2)$ (Modulus of $bold(hat(u)_2)$ and phase of $bold(hat(u)_1)$)

The procediment to create $hat(v)_2$ is the same as for $hat(v)_1$ but in this case we compute the modulus of $hat(u)_2$ and the phase of $hat(u)_1$. The resulting synthesized image $v_2$ is shown in @ModTextPhaseImage.

#figure(
  image("img/ModTextPhase.png", width: 30%),
  caption: "Image v2 (modulus of hat(u)_2 and phase of hat(u)_1)."
) <ModTextPhaseImage>

@ModTextPhaseImage shows that the synthesized image $hat(v)_2$ retains the structural geometry of image $hat(u)_1$ (roma.png), but adopts the intensity and textural characteristics of image $hat(u)_2$ (texture.png). Because the geometry of $hat(u)_1$ is highly structured, the shape of the car remains easily identifiable in $hat(v)_2$. Furthermore, since $hat(u)_2$ is a texture, its modulus imparts a vintage, print-like effect to the synthesized image. Visually, $hat(v)_2$ resembles an aged, printed photograph of an old car. This aesthetic shift is strictly due to the application of the modulus of $hat(u)_2$, which softens the high contrast and modern definition present in the original car image, creating a faded, historical appearance.

/*
2 Random Phase Noise (RPN)
Figure 2: Left: input image textil-1-gray.png. Right: input image textil-2
gray.png
The RPN texture synthesis method consist in synthesizing a texture im
age by randomizing its Fourier phase. That is, given an input texture u, the
synthesized image v is defined as:
ˆ
v(s, t) = |ˆu(s,t)|eiφ(s,t), (s,t) ∈ ˆ Ω
where φ(s,t) is a random phase. The algorithm is as follows:
(3)
1. Generate a random phase φ (hint: the phase of the DFT of a Gaussian
white noise is a random phase)
2. Compute the DFT of the input texture ˆu
3. Compute ˆv as defined in (3)
4. Compute the texture v as the inverse DFT of ˆv
Figure 3: Input image bricks.png.
2
a) Create a python function that performs the previous algorithm to synthesize
the textures: textil-1-gray.png and textil-2-gray.png (see Figure 2).
b) Comment the results.
c) Extend this algorithm to colour images and synthesize texture bricks.png
(see Figure 7). (Be careful with the coherence of the colour channels, new
colours should not appear.)
d) Comment the difference between the grayscale version and the colour ver
sion.
*/

= RANDOM PHASE NOISE (RPN)
In this second exercise we are going to study the Random Phase Noise (RPN) texture synthesis method. The main idea of this algorithm is to generate a new texture by preserving the modulus of the DFT of the original image, but replacing its phase with a random phase. Given an input texture $u$, the synthesized texture $v$ is defined as follows:

#align(center)[
#set math.equation(numbering: "(1)")
$ hat(v)(s, t) = |hat(u)(s, t)| e^(i phi(s, t)), quad (s, t) in hat(Omega) $ <RPNEquation>
]

In (@RPNEquation), $|hat(u)(s, t)|$ represents the modulus of the DFT of the input texture, while $phi(s, t)$ represents a random phase. This means that the synthesized image keeps the frequency content of the original texture but changes the spatial organization of its pixels.

The reason why this method is useful for texture synthesis is that many textures are mainly characterized by their frequency distribution. The modulus of the Fourier transform contains information about the scale of the details, the dominant frequencies, the roughness and the repetitive behaviour of the image. On the other hand, the phase contains most of the spatial arrangement of the image. Therefore, when the phase is randomized, the exact position of the original structures is lost, but the general textural appearance can still be preserved.

#grid(
  columns: (1fr, 1fr),
  gutter: 0.9em,

  [#figure(
    image("img/textil-1-gray.png", width: 60%),
    caption: "Input texture textil-1-gray.png."
  ) <ImgTextilOne>],

  [#figure(
    image("img/textil-2-gray.png", width: 60%),
    caption: "Input texture textil-2-gray.png."
  ) <ImgTextilTwo>],
)

== Grayscale RPN algorithm

The first part of the exercise consists in applying the RPN method to grayscale textures. Since grayscale images only have one intensity channel, the method can be applied directly to the image values.

The algorithm starts by generating a random phase. This is done by creating a Gaussian white noise image and taking the phase of its DFT. The phase of the DFT of Gaussian white noise behaves as a random phase, so it can be used to replace the phase of the original texture.

Then, the DFT of the input texture is computed. From this transform, only the modulus is preserved. This modulus contains the frequency information of the original texture. After that, the preserved modulus is combined with the random phase. Finally, the inverse DFT is computed to obtain the synthesized texture in the spatial domain.

The important point is that the output image does not copy the original texture pixel by pixel. Instead, it creates a new image with similar frequency characteristics. This means that the synthesized texture can have a similar granularity, roughness or periodicity, but the local structures appear in different positions.

#figure(
  image("img/Exercise2_1_output.png", width: 75%),
  caption: "Output of the grayscale RPN algorithm applied to textil-1-gray.png and textil-2-gray.png."
) <RPNGrayOutput>

== Comment on the grayscale results

@RPNGrayOutput shows the result of applying the RPN method to the two grayscale input textures. In both cases, the synthesized image keeps some visual characteristics of the original texture, but it does not preserve the exact spatial position of the details.

For textil-1-gray.png, the result is visually coherent because the original texture is mainly stochastic. It does not contain strong geometric shapes or clear objects. Therefore, preserving the Fourier modulus is enough to keep a similar grainy appearance. The synthesized texture has a similar scale of details and a similar roughness to the original one.

For textil-2-gray.png, the result is less structurally faithful. This texture has a more regular and organized pattern, so its appearance depends more strongly on the Fourier phase. When the phase is randomized, the precise organization of the pattern is lost. However, the synthesized image still preserves some global properties, such as the dominant frequencies and the general size of the texture elements.

This shows that RPN works better for random or homogeneous textures than for highly structured textures. The reason is that random textures are mainly described by their frequency content, while structured textures depend more on the phase, which contains the spatial arrangement of the image.

== Extension to colour images

The next step is to extend the RPN algorithm to colour images. A colour image has three channels: red, green and blue. The method could be applied independently to each channel, but this would create an important problem. If each channel uses a different random phase, the spatial relation between the red, green and blue components is broken. As a result, colours that were not present in the original image could appear.

To avoid this problem, the same random phase must be used for the three colour channels. Each channel keeps its own Fourier modulus because each colour channel has its own frequency content. However, all channels share the same randomized phase. This keeps the spatial relationship between the colour channels and prevents the appearance of unrealistic colours.

#figure(
  image("img/bricks.png", width: 35%),
  caption: "Input colour texture bricks.png."
) <ImgBricks>

#figure(
  image("img/Exercise2_4_output.png", width: 75%),
  caption: "Output of the colour RPN algorithm applied to bricks.png."
) <RPNBricksOutput>

== Comment on the colour result

@RPNBricksOutput shows the result of applying the colour RPN method to bricks.png. The synthesized image preserves part of the global appearance of the original texture. The reddish and brown colours of the bricks are still present because the Fourier modulus of each colour channel has been preserved.

However, the exact brick structure is not perfectly maintained. The regular arrangement of the bricks depends strongly on the Fourier phase. Since the phase has been randomized, the clear geometric organization of the wall is partially destroyed. As a result, the synthesized image keeps a brick-like appearance in terms of colour and frequency content, but it does not reproduce the original wall structure exactly.

This result confirms one of the limitations of the RPN method. It is suitable for stochastic textures, but it is less effective for textures with strong geometric structures. In structured textures such as bricks, the phase contains essential information about the position, alignment and shape of the elements.

== Difference between grayscale and colour RPN

The grayscale version is simpler because it only works with one channel. The algorithm only has to preserve the Fourier modulus of one image and replace its phase with a random phase.

The colour version is more delicate because it has to preserve the coherence between the three RGB channels. If a different random phase is used for each channel, the red, green and blue components are randomized differently. This breaks their spatial alignment and can generate artificial colours that were not present in the original image.

For this reason, the colour version uses the same random phase for all channels. This keeps the spatial relationship between the colour channels and produces more coherent colours. The result is still randomized, but the colours remain closer to the original ones.

In conclusion, grayscale RPN only has to preserve texture frequency information, while colour RPN must also preserve the relationship between colour channels. This is why using the same random phase for all RGB channels is necessary in the colour extension of the algorithm.


/*
3 Efros and Leung’s method
Given the input textures u1 and u2 in Figure 4 and the synthesized textures
generated with the Efros and Leung’s method in Figures 5 and 6 find the correct
patch size used in each synthesis. That is indicate for v1, v2, v3, v4, v5 and v6
in Figures 5 and 6 what patch size was used. The options are: 5 ×5, 9×9 and
33 ×33. Justify your choise in each case.
u1
u2
Figure 4: First row: on the left input image u1 (bricks-2.png) and on the right
its corresponding color map. Second row: on the left input image u2 (texture
2.png) and on the right its correspoding color map.
3
v1
v2
v3
Figure 5: Each row has a texture generated with the Efros and Leung’s method
and its corresponding copy map. Each row was generated with a different patch
size.
4
v4
v5
v6
Figure 6: Each row has a texture generated with the Efros and Leung’s method
and its corresponding copy map. Each row was generated with a different patch
size.
*/

= EFROS AND LEUNG’S METHOD

The matching patch size for each synthesized texture is as follows:
- v1: 33x33
- v2: 9x9
- v3: 5x5
- v4: 9x9
- v5: 33x33
- v6: 5x5

== 33x33 (v1 and v5)

These copies of map images of $v_1$ and $v_5$ (@efros_v1 and @efros_v5) demonstrate large and continuous areas of flat-colored regions. Large patch sizes mean that the algorithm is forced to find the macro-texture of the input image, thereby copying larger portions of the image as intact regions in order to preserve the structure of, say, the entire bricks and large holes of the sponge.

#grid(
  columns: (1fr, 1fr),
  gutter: 0.9em,

  [#figure(
    image("img/efros_v1.png", width: 100%),
    caption: "Copy map for v1 (33x33 patch size)."
  ) <efros_v1>],

  [#figure(
    image("img/efros_v5.png", width: 100%),
    caption: "Copy map for v5 (33x33 patch size)."
  ) <efros_v5>],
)

== 9x9 (v2 and v4)

Both the copy maps of $v_2$ (@efros_v2) and $v_4$ (@efros_v4) consist of color patches of intermediate sizes and some speckling. In these texture images, we can still see structural elements in terms of rigid macro-structures, but these structures have become more blurred or discontinuous in some places.

#grid(
  columns: (1fr, 1fr),
  gutter: 0.9em,

  [#figure(
    image("img/efros_v2.png", width: 100%),
    caption: "Copy map for v2 (9x9 patch size)."
  ) <efros_v2>],

  [#figure(
    image("img/efros_v4.png", width: 100%),
    caption: "Copy map for v4 (9x9 patch size)."
  ) <efros_v4>],
)

== 5x5 (v3 and v6)

The copies in @efros_v3 and @efros_v6 are extremely fragmented and appear like static noises. Very few patches result in details being extracted such as texture or colors, but fail entirely to extract anything larger than that. This is because very few patches can be found matching in a lot of places in the original image and thus result in random selection of patches across the image.

#grid(
  columns: (1fr, 1fr),
  gutter: 0.9em,

  [#figure(
    image("img/efros_v3.png", width: 100%),
    caption: "Copy map for v3 (5x5 patch size)."
  ) <efros_v3>],

  [#figure(
    image("img/efros_v6.png", width: 100%),
    caption: "Copy map for v6 (5x5 patch size)."
  ) <efros_v6>],
)




/*
4 Optional
Figure 7: Input image clouds.png.
a) Synthesize image clouds.png (see Figure 7) using the RPN method imple
mented in exercise 2 part c). Comment the result.
b) Generate a symmetric version w of cloud.png of size 2M × 2N, where
M×N isthe size of clouds.png, which follows the following scheme:
F
F F
F
c) Synthesize the image w using the RPN method implemented in exercise 2
part c).
d) Extract the upper left size of the synthesized image of size M ×N. Com
pare to the result in a).
e) Explain the difference between both results
*/
//put a name that is not "Optional"
= SYMMETRIC RANDOM PHASE NOISE (SRPN)
In this optional exercise we apply the Random Phase Noise method to the image clouds.png. The objective is to compare the direct RPN synthesis with a second approach based on a symmetric extension of the image. The main idea is that the DFT assumes periodicity at the image boundaries. Therefore, if the borders of the image do not match properly, discontinuities may appear and affect the synthesized texture.

== RPN applied directly to clouds.png

First, we synthesize the image clouds.png using the RPN method implemented in Exercise 2. In this case, the algorithm is applied directly to the original image. As in the previous exercise, the modulus of the Fourier transform is preserved and the phase is replaced by a random phase.

#figure(
  image("img/4_A_Output.png", width: 75%),
  caption: "Output of the RPN method applied directly to clouds.png."
) <RPNCloudsDirect>

@RPNCloudsDirect shows that the synthesized image preserves the general cloudy appearance of the original texture. This happens because the Fourier modulus keeps the frequency distribution of the image. Since clouds are a natural and mostly stochastic texture, RPN is able to generate a visually coherent result.

However, the result can contain some artifacts related to the boundaries of the image. This is because the Fourier transform treats the image as periodic. Therefore, the right border is implicitly connected to the left border, and the top border is connected to the bottom border. If these borders do not match smoothly, artificial discontinuities can appear in the synthesis.

== Symmetric extension of clouds.png

In the second part, we generate a symmetric version $w$ of the image clouds.png. If the original image has size $M times N$, the new image $w$ has size $2M times 2N$.

The construction follows a mirror scheme. The original image is placed in the upper-left part, a horizontally flipped version is placed on the upper-right part, a vertically flipped version is placed on the lower-left part, and a version flipped both horizontally and vertically is placed on the lower-right part.

#align(center)[
$ w = mat(
  F, "flip_h"(F);
  "flip_v"(F), "flip_v"("flip_h"(F))
) $
]

#figure(
  image("img/4_B_Output.png", width: 65%),
  caption: "Symmetric version of clouds.png with size 2M x 2N."
) <CloudsSymmetric>

@CloudsSymmetric shows the symmetric extension of the original cloud image. The purpose of this construction is to make the borders more continuous. Since each side is mirrored, the transition between opposite borders becomes smoother than in the original image.

This is useful because the DFT assumes that the image is periodic. By using a symmetric image, the periodic repetition creates fewer visible discontinuities at the boundaries.

== RPN applied to the symmetric image

After constructing the symmetric image $w$, we apply the RPN method to it. The process is the same as before: we compute the Fourier transform of $w$, preserve its modulus, replace its phase with a random phase, and then compute the inverse Fourier transform.

#figure(
  image("img/4_C_Output.png", width: 65%),
  caption: "RPN synthesis applied to the symmetric version of clouds.png."
) <RPNCloudsSymmetric>

@RPNCloudsSymmetric shows the RPN synthesis obtained from the symmetric image. Since the input image is larger and has smoother boundary transitions, the Fourier transform is less affected by artificial border discontinuities.

The result is still random because the phase has been replaced, but the global cloudy texture is preserved. The use of the symmetric extension helps to reduce artifacts caused by the periodic assumption of the DFT.

== Cropping and comparison

In this part, we extract the upper-left region of the synthesized symmetric image. The extracted region has the same size $M times N$ as the original clouds.png. This cropped image is then compared with the result obtained by applying RPN directly to the original image.

#figure(
  image("img/4_D_Output.png", width: 85%),
  caption: "Comparison between the original image, direct RPN, and cropped symmetric RPN."
) <RPNCloudsComparison>

@RPNCloudsComparison compares the original image, the direct RPN result and the cropped result obtained from the symmetric RPN synthesis. Both synthesized images preserve the general cloud-like texture because both methods keep the Fourier modulus of the original information.

However, the symmetric version usually produces a smoother result near the borders. This is because the symmetric extension reduces the discontinuities that appear when the Fourier transform assumes periodic repetition of the image. In contrast, the direct RPN method may introduce more visible artifacts if the borders of the original image are not naturally continuous.

== Explanation of the difference

The main difference between both results comes from the boundary behaviour of the Fourier transform. When we apply the DFT to an image, the image is treated as if it were periodically repeated in all directions. This means that the left border is assumed to continue from the right border, and the top border is assumed to continue from the bottom border.

If the borders of the original image do not match, this periodic repetition creates artificial jumps. These jumps introduce high-frequency components that can affect the RPN synthesis and produce visible artifacts.

The symmetric extension reduces this problem. By reflecting the image horizontally and vertically, the borders become more continuous. As a result, the periodic repetition assumed by the DFT is smoother. When RPN is applied to this symmetric image and the upper-left part is extracted, the final texture usually contains fewer boundary artifacts.

In conclusion, direct RPN is simple and works reasonably well for stochastic textures such as clouds. However, symmetric RPN improves the result because it reduces boundary discontinuities before applying the Fourier transform. Therefore, the cropped symmetric RPN result is usually smoother and more natural than the direct RPN result.