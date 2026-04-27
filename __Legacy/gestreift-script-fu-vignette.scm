; my test

(define (gestreift-script-fu-vignette
		theImage
		baseLayer
		color
		feather
	)

	; the process should be undone with a single undo
	(gimp-image-undo-group-start theImage)

	(define drawableWidth  (car (gimp-drawable-width  baseLayer)))
	(define drawableHeight (car (gimp-drawable-height baseLayer)))
	(define vignetteLayer (car (gimp-layer-new theImage drawableWidth drawableHeight RGBA-IMAGE "Vignette" 30 LAYER-MODE-SOFTLIGHT)))
	(gimp-image-insert-layer theImage vignetteLayer 0 0)

	(define currentForeground (car (gimp-context-get-foreground)))

	(if (= (car (gimp-selection-is-empty theImage)) TRUE)
		(gimp-image-select-ellipse theImage CHANNEL-OP-REPLACE 0 0 drawableWidth drawableHeight)
	)

	(gimp-selection-feather theImage feather)
	(gimp-selection-invert theImage)

	; set the color based on SF-OPTION _"Color" ...
	(if (= color 0)	(gimp-context-set-foreground "#000000")
		(if (= color 1) (gimp-context-set-foreground "#450002")
		(gimp-context-set-foreground "#FFFFFF")
		)
	)

	(gimp-edit-bucket-fill vignetteLayer BUCKET-FILL-FG LAYER-MODE-NORMAL 100 0 FALSE 0 0)

	(gimp-context-set-foreground currentForeground)

	(gimp-selection-none theImage)

	;Ensure the updated image is displayed now
	(gimp-displays-flush)

	; stop undo
	(gimp-image-undo-group-end theImage)

) ;end define

(script-fu-register "gestreift-script-fu-vignette"
	_"Vignette ..."
	"Creates a vignette in a new layer. If there is no selection an ellipse covering the whole image will be selected."
	"Andreas"
	"andreas@gestreift.net"
	"April 2022"
	"*"
	SF-IMAGE		"Image"     	0
	SF-DRAWABLE		"Drawable"  	0
	SF-OPTION   		_"Color"	'("Black" "Evil Red")
	SF-ADJUSTMENT 		_"Feather" 	'(850 100 4000 1 100 0 SF-SLIDER)
)

(script-fu-menu-register "gestreift-script-fu-vignette"
                         "<Image>/Filters/gestreift.net")
