; my test

(define (gestreift-script-fu-soft-skin
		theImage
		baseLayer
		repeat
		brighten
	)

	; the process should be undone with a single undo
	(gimp-image-undo-group-start theImage)

	(define softskinLayer (car (gimp-image-get-active-drawable theImage )))
	(gimp-item-set-name softskinLayer "Soft Skin")

	(let ((i 0))

		(while (< i repeat)
			(plug-in-gmic-qt 1 theImage softskinLayer 1 0 "-v - -fx_equalize_details 5,0.5,0,10,2,0,0,0,2,0,0,0,2,0,0,0,2,0,11,0,0,32,0,50,50") ; Details -> Details Equalizer
			(set! i (+ 1 i))
		)
	)

	(define softskinLayerOverlay (car (gimp-layer-copy softskinLayer TRUE )))
	(gimp-image-insert-layer theImage softskinLayerOverlay 0 0)
	(gimp-item-set-name softskinLayerOverlay "Soft Skin (Overlay)")
	(gimp-layer-set-mode softskinLayerOverlay LAYER-MODE-OVERLAY)
	(gimp-layer-set-opacity softskinLayerOverlay 80)

	(plug-in-gmic-qt 1 theImage softskinLayerOverlay 1 0 "-v - -fx_highpass 8,1.4,0,1,0")

	(define softskinLayer (car (gimp-image-merge-down theImage softskinLayerOverlay EXPAND-AS-NECESSARY)))

	(if (= brighten TRUE)
	    	(begin
		(define softskinLayerOverlay (car (gimp-layer-copy softskinLayer TRUE )))
		(gimp-image-insert-layer theImage softskinLayerOverlay 0 0)
		(gimp-item-set-name softskinLayerOverlay "Soft Skin (Brighten)")
		(gimp-layer-set-mode softskinLayerOverlay LAYER-MODE-SOFTLIGHT)
		(gimp-layer-set-opacity softskinLayerOverlay 50)
		(gimp-drawable-desaturate softskinLayerOverlay DESATURATE-LIGHTNESS)
		)
	)

	;Ensure the updated image is displayed now
	(gimp-displays-flush)

	; stop undo
	(gimp-image-undo-group-end theImage)

) ;end define

(script-fu-register "gestreift-script-fu-soft-skin"
	_"Draw skin softly ..."
	"This script uses the Details Equalizer out of G'MIC to soften the skin and is sharpening the output with a 80% - high pass filter. Additionally it creates a layer of bright skin. Do not forget to apply a layer mask and keep the skin-parts only!"
	"Andreas"
	"andreas@gestreift.net"
	"March 2022"
	"*"
	SF-IMAGE		"Image"     	0
	SF-DRAWABLE		"Drawable"  	0
	SF-ADJUSTMENT		_"Repetitions"	'(1 1 5 1 1 0 SF-SLIDER)
	SF-TOGGLE		_"Brighten"	FALSE
)

(script-fu-menu-register "gestreift-script-fu-soft-skin"
                         "<Image>/Filters/gestreift.net")

