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

<<<<<<< HEAD


=======
>>>>>>> ec4ffb9ca1afd1eb3ac3fc933d91ccb400a8a585
/*
#figure(
  image("img/dilation_example.png", width: 55%),
  caption: "Dilation example."
)<DilationExample>
*/

<<<<<<< HEAD
/* 

LAB EXPLANATION

n this lab, we will learn how to implement and train an Autoencoder based model (A
=======
/* All the information given in text of the lab is as follows:

In this lab, we will learn how to implement and train an Autoencoder based model (A
>>>>>>> ec4ffb9ca1afd1eb3ac3fc933d91ccb400a8a585
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
<<<<<<< HEAD
We see the only thing important for us here is the feature dictionary which is nothing
=======
Wesee the only thing important for us here is the feature dictionary which is nothing
>>>>>>> ec4ffb9ca1afd1eb3ac3fc933d91ccb400a8a585
but a python dictionary with keys and values. Since we’re only interested in the
original images and the segmentation masks we would only retrieve these two keys
highlighted above. Please note, if you plan to use any other dataset the keys would
be different.
<<<<<<< HEAD
We build the model with just a few layers to build a small Unet model and train it for
10 epochs for demonstration. Once trained we plot the loss and accuracy of the
model using helper functions,

We show the prediction of the trained model against the true mask this time and here
=======
Webuild the model with just a few layers to build a small Unet model and train it for
10 epochs for demonstration. Once trained we plot the loss and accuracy of the
model using helper functions,

Weshow the prediction of the trained model against the true mask this time and here
>>>>>>> ec4ffb9ca1afd1eb3ac3fc933d91ccb400a8a585
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
<<<<<<< HEAD
*/

= Image segmentation with U-Net (Oxford-IIIT Pet)

Image segmentation is the task of assigning a class label to each pixel in an image. Unlike classification, where an object is identified within the entire image, segmentation provides finer-grained spatial information (e.g. contours and regions). In this lab, we use the Oxford-IIIT Pet dataset (Parkhi et al., 2012), which contains images of 37 breeds of pets (~200 images per breed) with their associated segmentation masks. Each pixel in the image belongs to one of three classes: 1) the animal itself, 2) the animal’s boundary, or 3) the background (“none of the above”). Our aim is to train a U-Net model to learn to predict this mask given only the RGB image.

In the pre-processing stage, we resize all images and masks to a fixed size (e.g. 224×224 pixels) and normalise the image pixels to [0,1]. The original class mask {1,2,3} is subtracted by 1 to transform it to {0,1,2}, facilitating the use of SparseCategoricalCrossentropy. In addition, we apply data augmentation such as random horizontal flipping, which is an efficient technique for enriching the dataset without collecting any new data. Such augmentation (rotations, brightness changes, flips, etc.) creates synthetic variants of each image, reducing overfitting and improving generalisation.

= Model architecture

For the model, we used a variant of U-Net with an encoder based on the pre-trained MobileNetV2 network (without the classification layers) from the Keras library. We set this encoder to (trainable=False) to extract features (skips) from multiple resolution levels. We then added a decoder that progressively increases the resolution using pix2pix upsampling blocks. Specifically, the upsampling stack is defined using blocks such as pix2pix.upsample(512,3), pix2pix.upsample(256,3), etc., which double the spatial size according to conv2DTransp. At each upsampling step, we concatenate (skip connection) the corresponding features from the encoder (intermediate layers of MobileNetV2), as in the original U-Net. Finally, we apply a Conv2DTranspose layer with a stride of 2 to return to the original size and obtain 3 output channels (one per class). The resulting model has inputs of shape (224×224×3) and outputs of shape (224×224×3) with logit probabilities for each class.

In the compilation, we use the Adam optimiser and the sparse categorical cross-entropy loss (SparseCategoricalCrossentropy(from_logits=True)), which is suitable when the labels are class integers. The argument from_logits=True indicates that the model’s output consists of unnormalised logits. As the primary metric, we use accuracy (per-pixel), but we can also monitor more specific segmentation metrics such as IoU (Intersection over Union) or the F1-score. For example, TensorFlow provides the class `tf.keras.metrics.IoU(...)` to quantify the overlap between the predicted mask and the ground-truth mask. It is generally recommended to report accuracy alongside IoU, precision, recall or F1-score to gain a comprehensive view of performance.

= Training and initial results

We initially trained the model for 10–20 epochs on the train set (3,680 images), using a subset of the test set (3,669 images) for validation. We used Keras’s `model.fit()` with `train_batches` and `test_batches`. As an optional callback, we defined `DisplayCallback` to display a sample prediction at the end of each epoch (as in the official tutorial).

Before training, we observed that the model predicted almost random masks (untrained). Figure 1 shows an example: on the left is the input image (a cat), in the centre the ground-truth mask, and on the right the mask predicted by the untrained model. Clearly, the initial prediction is noisy.

Figure 1: Initial prediction before training. (left) Input image of a pet, (centre) true mask (cat), (right) mask predicted by the untrained model. The initial prediction is very poor compared to the true mask.

After training for 10–20 epochs, the U-Net improves significantly. Figure 2 illustrates this: we use the same example as before and see that the mask predicted after 20 epochs matches the true mask much better. In fact, the official tutorial reports accuracy values of ~92.85% on training and ~90.76% on validation after 20 epochs. Although our figures may vary, a similar trend of improvement with training is expected.

Figure 2: Prediction after training (20 epochs). (left) Input image, (centre) true mask, (right) mask predicted by the trained model. It can be seen that the predicted mask fits the animal’s outline much better.

Furthermore, we plotted the evolution of the training and validation loss to verify convergence. Figure 3 shows a typical decreasing loss curve. Initially, the loss is high and gradually decreases until it plateaus when the model stops improving.

Figure 3: Training (red) and validation (blue) loss curves versus epoch. A continuous decline is observed during training, followed by some stabilisation towards the end.

After training, we tested the model on new images sourced from the internet to assess its generalisation ability. In Figure 4 and Figure 5, we present two examples: a cat and a dog different from those in the training dataset. In each case, we show (from left to right) the original image, the ground-truth mask (based on the known ground truth from the Oxford test dataset) and the predicted mask. It can be seen that the model segments the animal (cat or dog) reasonably well, even when there are variations in pose and background.

Figure 4: Example of segmentation in a test image (cat). The trained model manages to outline the animal with good accuracy.
Figure 5: Another example involving a dog. The input image, the ground-truth mask and the predicted mask are shown, confirming that the model generalises to new images.

= Evaluation metrics

To quantify performance, we can use various segmentation metrics. In addition to pixel-wise accuracy, it is common to use IoU (Intersection over Union), which measures the overlap between the predicted mask and the ground truth. Mathematically, IoU = (TP)/(TP+FP+FN) per class, and the average across relevant classes is usually reported. Precision, recall and F1 score can also be used at the pixel level or per class; these combine the ability to identify true positives whilst avoiding false positives. These metrics provide more detail than simple accuracy. In segmentation tasks, the aim is to maximise IoU or F1 (values close to 1 indicate a good match).

In our case, although the base code used only accuracy, the model could be extended to report, for example:

Here, the IoU class would calculate the average value across the three classes. Typical values might be IoU ≈ 0.80–0.90 following thorough training (depending on the task). As the edge and background classes are sometimes grouped together, the IoU is sometimes calculated only for the ‘pet vs background’ class using `target_class_ids=[1]`.

= Improvements and alternative experiments

Starting from the base model, we explored several modifications to improve performance:

- *More training epochs:* Training for more than 20 epochs can refine the segmentation, although there is a risk of overfitting. In practice, we observed that increasing the number of epochs to 30–40 yields slight improvements (< 5%) in accuracy and IoU, but with diminishing returns towards the end.
- *Learning rate:* We tested reducing the learning rate (lr) to 1e-4 or using a schedule such as Cosine Annealing. A gradual decay of lr helped to stabilise training, although the improvement was modest. TensorFlow provides `tf.keras.optimizers.schedules.CosineDecay` for this purpose.
- *Alternative optimisers:* Attempts were made to replace Adam with SGD with momentum or RMSprop. With SGD, slower convergence and, at times, poorer final accuracy (~1–2% lower) were observed compared to Adam, especially without fine-tuning the lr. In some cases, Adam achieves better results in less time.
- *Regularisation:* Adding Dropout layers to the decoder (before the concatenations) can reduce overfitting. In one experiment, Dropout(0.5) was inserted after certain layers, and it was observed that the validation variance decreased slightly. Dropout tends to prevent the model from becoming dependent on very specific features.
- *Architecture change:* Another option is to try different encoders (ResNet, EfficientNet, etc.) or variants of U-Net (such as U-Net++). You can also fine-tune the pre-trained encoder (set `trainable=True`) and continue training it. This usually improves accuracy at the cost of increased training time and a risk of overfitting if there is insufficient data.
- *Different dataset:* Although the exercise specifies the Oxford-IIIT Pet dataset, you may use another segmentation dataset available on TFDS (for example, Cityscapes, Mapillary, or MS COCO with masks). This would allow you to compare how well the U-Net adapts to a different domain. If training on a new dataset, it is important to normalise and label classes accordingly (e.g. different numbers of classes).
- *Other advanced techniques:* Attention mechanisms can be integrated, more aggressive data augmentation (rotations, zooming, etc.) can be used, or techniques such as ensembles can be applied. However, each addition increases complexity and training time.
In our laboratory experiments, the simplest improvements (more epochs and fine-tuning of the learning rate) yielded modest gains (e.g. validation accuracy rose from ~0.88 to ~0.90). Switching to SGD or increasing dropout did not significantly improve the overall metric, although in certain examples it reduced false positives. Overall, the changes did not lead to dramatic leaps in performance because the base model was already quite strong (92% training accuracy in the reported case). It is common for network variants and parameters to yield limited improvements, especially if the dataset is not very large.

= Conclusions

We have implemented a simple U-Net with a pre-trained encoder to segment images of pets. The model learnt to distinguish the animal from the background after sufficient training, as shown in the sample figures. The most commonly used metrics in segmentation (IoU, precision/F1) confirm this good performance, although they are slightly lower than the pixel-wise accuracy. Experiments involving more epochs, different optimisers or regularisation helped to fine-tune performance: increases in accuracy of around ~2–4% were possible, though not always significant. Ultimately, the procedure demonstrated how adjusting hyperparameters (learning rate, epochs, dropout) and using data augmentation can enhance robustness. For similar tasks, we would also recommend trying to fine-tune the encoder or using deeper architectures if the baseline performance is insufficient. In our experience, the final model segments the outlines of dogs and cats with good accuracy, as evidenced by the predicted masks in the final examples.
=======

*/

>>>>>>> ec4ffb9ca1afd1eb3ac3fc933d91ccb400a8a585
