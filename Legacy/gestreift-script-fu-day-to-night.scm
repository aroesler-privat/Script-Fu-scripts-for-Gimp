; my test

(define (gestreift-script-fu-day-to-night
		theImage
		baseLayer
	)

  	(gimp-progress-init _"Day to Night" -1)
	(gimp-progress-set-text _"Creating layers. Do not forget to adjust the opacity and to use layer masks ...")
	(gimp-progress-pulse)

	; the process should be undone with a single undo
	(gimp-image-undo-group-start theImage)

	(define dayToNightBaseLayer (car (gimp-layer-new-from-drawable baseLayer theImage)))
	(gimp-image-insert-layer theImage dayToNightBaseLayer 0 0)
	(gimp-item-set-name dayToNightBaseLayer "Day to Night: Base")
	(plug-in-gmic-qt 1 theImage dayToNightBaseLayer 1 0 "-v - -jl_colorgrading 0,10,1,0.8917,10,0,0,0,0,0,1,0.1,0.15,1,25,0,0,70,0,0,30,180,0,1,0,0,0")

	(define dayToNightDarkLayer (car (gimp-layer-new-from-drawable dayToNightBaseLayer theImage)))
	(gimp-image-insert-layer theImage dayToNightDarkLayer 0 0)
	(gimp-item-set-name dayToNightDarkLayer "Day to Night: Darken")
	(gimp-layer-set-mode dayToNightDarkLayer LAYER-MODE-MULTIPLY)
	(gimp-layer-set-opacity dayToNightDarkLayer 75)

	(define drawableWidth  (car (gimp-drawable-width  baseLayer)))
	(define drawableHeight (car (gimp-drawable-height baseLayer)))
	(define dayToNightBlueLayer (car (gimp-layer-new theImage drawableWidth drawableHeight RGBA-IMAGE "Day to Night: Blue" 75 LAYER-MODE-MULTIPLY)))
	(gimp-image-insert-layer theImage dayToNightBlueLayer 0 0)

	(define currentForeground (car (gimp-context-get-foreground)))
	(gimp-context-set-foreground "#131244")
	(gimp-drawable-fill dayToNightBlueLayer FILL-FOREGROUND)
	(gimp-context-set-foreground currentForeground)

	;Ensure the updated image is displayed now
	(gimp-displays-flush)

	; stop undo
	(gimp-image-undo-group-end theImage)

	(gimp-progress-end)

) ;end define

(script-fu-register "gestreift-script-fu-day-to-night"
	_"Day to night ..."
	"Creates three new adjustable layers which are multiplied to the actual layer. Those layers give daylight-images a night-look."
	"Andreas"
	"andreas@gestreift.net"
	"April 2022"
	"*"
	SF-IMAGE		"Image"     0
	SF-DRAWABLE		"Drawable"  0
)

(script-fu-menu-register "gestreift-script-fu-day-to-night"
                         "<Image>/Filters/gestreift.net")
