# Collection of Script-Fu scripts for Gimp 3.x
I've finally made my Script-Fu workflows compatible with GIMP 3. It was a real pain... Scheme isn't a very pleasant language ;-). **Note: Almost all workflows assume that G'MIC is installed and configured.**

## Install
Simply copy all the `script-fu-gestreift` and the `modules` with all its contents into the `plug-ins` folder in your GIMP installation and restart GIMP. The workflows should now appear under Filter -> gestreift.net.

If you don't know where your `plug-ins` folder is, check in GIMP under Edit -> Preferences -> Folders -> Plug-Ins.

## Workflows
### 01 Ignite into a fire
In some of my images, I use this workflow to bring out the vibrancy of the colors. It’s a simple soft light layer with a blur filter. This used to be "Empower 1" in the workflows for Gimp 2.x. Now the steps are applied within a layer-group.

### 02 Temperature & Brightness
This filter uses G'MIC's "Temperature Balance" and "Normalize Brightness" functions to make the image look more natural (or less natural, depending on the original image). This used to be "Empower 1" in the workflows for Gimp 2.x. Now the steps are applied within a layer-group.

### opt. Luminance Masks
Setting up proper luminance masks always was a time consuming job. This one creates a layer-group consisting of DDD, DD, D, M, L, LL and LLL pieces of the image. It starts from whatever is visible. 

### opt. Skin Glow
This is two lights & shadows presets, again applied as a layer-group.

### opt. Vignette
Adds a simple vignette. To be honest, I only built this because I wanted to see how the dialogs work in Script-Fu.

### ZZ Sharpen
Sharpens the image via G'MIC (Smooth [Patch-Based] + Sharpen [Octave Sharpening]). It is named ZZ as it always should be applied as one of the last steps.
