; my test

(define (gestreift-script-fu-high-pass-sharpen
		theImage
		baseLayer
	)

	; the process should be undone with a single undo
	(gimp-image-undo-group-start theImage)

	(define sharpenLayer (car (gimp-layer-new-from-drawable baseLayer theImage)))
	(gimp-image-insert-layer theImage sharpenLayer 0 0)
	(gimp-item-set-name sharpenLayer "Sharpen (high-pass)")
	(gimp-layer-set-opacity sharpenLayer 80)
	(gimp-layer-set-mode sharpenLayer LAYER-MODE-OVERLAY)

	(plug-in-gmic-qt 1 theImage sharpenLayer 1 0 "-v - -fx_highpass 8,1.4,0,1,0")

	;Ensure the updated image is displayed now
	(gimp-displays-flush)

	; stop undo
	(gimp-image-undo-group-end theImage)

) ;end define

(script-fu-register "gestreift-script-fu-high-pass-sharpen"
	_"Sharpen (high-pass) ..."
	"This script ..."
	"Andreas"
	"andreas@gestreift.net"
	"March 2022"
	"*"
	SF-IMAGE		"Image"     0
	SF-DRAWABLE		"Drawable"  0
)

(script-fu-menu-register "gestreift-script-fu-high-pass-sharpen"
                         "<Image>/Filters/gestreift.net")

