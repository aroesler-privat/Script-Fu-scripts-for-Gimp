; my test

(define (gestreift-script-fu-empower-1
		theImage
		baseLayer
	)

	; the process should be undone with a single undo
	(gimp-image-undo-group-start theImage)

	(define empowerLayer (car (gimp-layer-new-from-drawable baseLayer theImage)))
	(gimp-image-insert-layer theImage empowerLayer 0 0)
	(gimp-item-set-name empowerLayer "Empower 1")
	(gimp-layer-set-mode empowerLayer LAYER-MODE-SOFTLIGHT)
	(gimp-layer-set-opacity empowerLayer 50)

	(gimp-drawable-desaturate empowerLayer DESATURATE-LIGHTNESS)
	(plug-in-vinvert 1 theImage empowerLayer)
	(plug-in-gmic-qt 1 theImage empowerLayer 1 0 "-v - -fx_blur_dof 3,16,0,0,50,50,1,1,0,1,0,0")

	;Ensure the updated image is displayed now
	(gimp-displays-flush)

	; stop undo
	(gimp-image-undo-group-end theImage)

) ;end define

(script-fu-register "gestreift-script-fu-empower-1"
	_"Empower 1 ..."
	"Copies the drawable layer into a new one ..."
	"Andreas"
	"andreas@gestreift.net"
	"March 2022"
	"*"
	SF-IMAGE		"Image"     0
	SF-DRAWABLE		"Drawable"  0
)

(script-fu-menu-register "gestreift-script-fu-empower-1"
                         "<Image>/Filters/gestreift.net")
