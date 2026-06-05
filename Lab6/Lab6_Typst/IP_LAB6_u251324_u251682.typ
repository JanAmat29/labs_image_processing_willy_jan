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

        [#text(size: 16pt, weight: "bold", fill: black)[Assignment Lab 6]],
      ),
    )
  },
)

#set text(font: "Computer Modern", size: 11pt, lang: "en", fill: black)
#set par(justify: true, leading: 0.85em)
#show figure.caption: set text(size: 0.85em)

#align(center)[
  #text(size: 24pt, weight: "bold")[Image Segmentation]
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

/* All the information given in text of the lab is as follows:

In this lab, we will learn how to implement and train an Autoencoder based model (A
Simple UNET architecture) to segment pet images on “oxford_iiit_pet” dataset. A
simple baseline model has been provided to you on your tutorial notebook. Here we
would break down the code structure for you for better understanding.
Below is an example of a dog image and the true segmentation mask that we are
interested to predict and the predicted mask on the extreme right show predictions
without any training. Our objective is to make the predicted mask as close to true
mask as possible.
Let us first inspect the dataset after downloading it online, let us see what the
dataset contains and what data exactly do we need for training this model, since we
have loaded the dataset using tensorflow dataset, we can check the structure of the
dataset by printing ds_info:
Wesee the only thing important for us here is the feature dictionary which is nothing
but a python dictionary with keys and values. Since we’re only interested in the
original images and the segmentation masks we would only retrieve these two keys
highlighted above. Please note, if you plan to use any other dataset the keys would
be different.
Webuild the model with just a few layers to build a small Unet model and train it for
10 epochs for demonstration. Once trained we plot the loss and accuracy of the
model using helper functions,

Weshow the prediction of the trained model against the true mask this time and here
you can see a significant difference in predicted mask,
Finally, Any random pet image from the internet is downloaded and we test our
model on that, let’s see how good our model prediction is on a real life image outside
our dataset, this is also demonstrated in the tutorial notebook as well,
Objective:
Given all these examples to you, your job in this lab is to improve the performance
of the model compared to the baseline model.
Options to explore:- Train for more epochs- Modify learning rate (LR)- Modify the Optimizer (SGD, Adam, ...)- Learning Rate Schedulers (Cosine Annealing)
Also, You’re encouraged to change the dataset from oxform iit pet to any other
dataset online available on the internet or on tfds. You can further compare the loss
and accuracy of this baseline model vs your improved models based on the changes
you have made.
You can further analyse other performance matrices other than accuracy such as,
precision, recall, F1 score.
You need to submit a comprehensive report along with results comparing this
baseline model and your models highlighting your methodology. If model 1 (based on
some changes) does not improve the model performance you can still mention that
in your report but justify your answer why it did not work. You can check the list of
datasets available on tfds using this code,
Check this url to find more information about the datasets,
https://www.tensorflow.org/datasets/catalog/overview

*/

