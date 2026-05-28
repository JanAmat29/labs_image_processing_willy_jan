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
