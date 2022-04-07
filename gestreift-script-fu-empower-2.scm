; my test

(define (gestreift-script-fu-empower-2
		theImage
		baseLayer
	)

	; the process should be undone with a single undo
	(gimp-image-undo-group-start theImage)

	(define empowerLayer (car (gimp-layer-new-from-drawable baseLayer theImage)))
	(gimp-image-insert-layer theImage empowerLayer 0 0)
	(gimp-item-set-name empowerLayer "Empower 2")
	(gimp-layer-set-opacity empowerLayer 50)

	(plug-in-gmic-qt 1 theImage empowerLayer 1 0 "-v - -gcd_temp_balance 0,0,1.2,0")
	(plug-in-gmic-qt 1 theImage empowerLayer 1 0 "-v - -gcd_normalize_brightness 0,50,0,3,0,0")

	;Ensure the updated image is displayed now
	(gimp-displays-flush)

	; stop undo
	(gimp-image-undo-group-end theImage)

) ;end define

(script-fu-register "gestreift-script-fu-empower-2"
	_"Empower 2 ..."
	"Copies the drawable layer into a new one ..."
	"Andreas"
	"andreas@gestreift.net"
	"March 2022"
	"*"
	SF-IMAGE		"Image"     0
	SF-DRAWABLE		"Drawable"  0
)

(script-fu-menu-register "gestreift-script-fu-empower-2"
                         "<Image>/Filters/gestreift.net")
