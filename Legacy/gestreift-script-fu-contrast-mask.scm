; my test

(define (gestreift-script-fu-contrast-mask
		theImage
		baseLayer
	)

	; the process should be undone with a single undo
	(gimp-image-undo-group-start theImage)

	(define contrastmaskLayer (car (gimp-layer-new-from-drawable baseLayer theImage)))
	(gimp-image-insert-layer theImage contrastmaskLayer 0 0)
	(gimp-item-set-name contrastmaskLayer "Contrast Mask")
	(gimp-layer-set-mode contrastmaskLayer LAYER-MODE-SOFTLIGHT)

	(gimp-drawable-invert contrastmaskLayer TRUE)
	(gimp-drawable-desaturate contrastmaskLayer DESATURATE-LIGHTNESS)

	;Ensure the updated image is displayed now
	(gimp-displays-flush)

	; stop undo
	(gimp-image-undo-group-end theImage)

) ;end define

(script-fu-register "gestreift-script-fu-contrast-mask"
	_"Create contrast mask ..."
	"Copies the drawable layer into a new one and creates a contrast mask out of it. Do not forget to maybe adjust the opacity and/or to unmask parts of the image."
	"Andreas"
	"andreas@gestreift.net"
	"March 2022"
	"*"
	SF-IMAGE		"Image"     0
	SF-DRAWABLE		"Drawable"  0
)

(script-fu-menu-register "gestreift-script-fu-contrast-mask"
                         "<Image>/Filters/gestreift.net")
