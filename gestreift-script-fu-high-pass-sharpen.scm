; my test

(define (gestreift-script-fu-high-pass-sharpen
		theImage
		baseLayer
		deNoise
		highPass
		unsharpMask
	)

	; the process should be undone with a single undo
	(gimp-image-undo-group-start theImage)

	(if (= deNoise TRUE)	
		(begin
			(define deNoiseLayer (car (gimp-layer-new-from-drawable baseLayer theImage)))		
			(gimp-image-insert-layer theImage deNoiseLayer 0 0)
			(gimp-item-set-name deNoiseLayer "MS NL-Means C Noise2")
			(plug-in-gmic-qt 1 theImage deNoiseLayer 1 0 "-v - -ms_nlmeans_c_noise2_p 3,1,0,0,0,0,0,10,2,4,2,7,0,0,0,0")
		)
	)

	(if (= highPass TRUE)
		(begin
			(if (= deNoise TRUE)
				(define sharpenLayer (car (gimp-layer-new-from-drawable deNoiseLayer theImage)))
				(define sharpenLayer (car (gimp-layer-new-from-drawable baseLayer theImage)))
			)
			(gimp-image-insert-layer theImage sharpenLayer 0 0)
			(gimp-item-set-name sharpenLayer "Sharpen (high-pass)")
			(gimp-layer-set-opacity sharpenLayer 50)
			(gimp-layer-set-mode sharpenLayer LAYER-MODE-OVERLAY)
			(plug-in-gmic-qt 1 theImage sharpenLayer 1 0 "-v - -fx_highpass 8,1.4,0,1,0")
		)
	)

	(if (= unsharpMask TRUE)
		(begin
			(define unsharpMaskLayer (car (gimp-layer-new-from-visible theImage theImage "Unsharp Mask")))
			(gimp-image-insert-layer theImage unsharpMaskLayer 0 0)
			(plug-in-gmic-qt 1 theImage unsharpMaskLayer 1 0 "-v - -iain_pixel_denoise_p 1,2,11,0,1")
			(plug-in-unsharp-mask RUN-NONINTERACTIVE theImage unsharpMaskLayer 0.850 0.850 0)
		)
	)

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
	SF-IMAGE		"Image"     			0
	SF-DRAWABLE		"Drawable"  			0
	SF-TOGGLE		_"De-Noise"				TRUE
	SF-TOGGLE		_"Highpass-Sharpen"		TRUE
	SF-TOGGLE		_"Unscharf maskieren"	TRUE
)

(script-fu-menu-register "gestreift-script-fu-high-pass-sharpen"
                         "<Image>/Filters/gestreift.net")

