# Collection of Script-Fu scripts for Gimp 2.x
I've packaged some of my workflows into a few Script-Fu scripts to make my daily work easier. Almost all workflows assume that G'MIC is installed and configured. **Note: These scripts only work with GIMP 2.x!**

## Install
Simply copy all the scripts into the `scripts` folder in your GIMP installation and restart GIMP. The workflows should now appear under Filter -> gestreift.net.

If you don't know where your `scripts` folder is, check in GIMP under Edit -> Preferences -> Folders -> Scripts.

## Workflows
### Contrast Mask
Apply a contrast mask to the image to lighten dark areas or darken light areas. Adjust the strength using the opacity slider!

### Day to Night
A simple workflow for turning a daytime scene into a nighttime scene. Don’t expect any magic - the results aren’t always outstanding.

### Empower 1
In some of my images, I use this workflow to bring out the vibrancy of the colors. It’s a simple soft light layer with a blur filter.

### Empower 2
This filter uses G'MIC's "Temperature Balance" and "Normalize Brightness" functions to make the image look more natural (or less natural, depending on the original image).

### Eye Glow
Select the eyes using the Lasso Tool and copy them to a separate layer, then apply this workflow. It will add a more or less exaggerated glow to the eyes.

### Vignette
Adds a simple vignette. To be honest, I only built this because I wanted to see how the dialogs work in Script-Fu.
