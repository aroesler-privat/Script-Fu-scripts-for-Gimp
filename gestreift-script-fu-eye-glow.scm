; my test

(define (gestreift-script-fu-eye-glow
		theImage
		baseLayer
	)

	; the process should be undone with a single undo
	(gimp-image-undo-group-start theImage)

	(define glowingeyesLayer (car (gimp-image-get-active-drawable theImage )))
	(gimp-item-set-name glowingeyesLayer "Glowing Eyes")

	(plug-in-gmic-qt 1 theImage glowingeyesLayer 1 0 "-v - -fx_equalize_local_histograms 75,2,4,100,8,1,16,0,50,50") ; Details -> Equalize Local Histograms
	(plug-in-gmic-qt 1 theImage glowingeyesLayer 1 0 "-v - -fx_equalize_local_histograms 75,2,4,100,8,1,16,0,50,50") ; Details -> Equalize Local Histograms
	(plug-in-gmic-qt 1 theImage glowingeyesLayer 1 0 "-v - -fx_freaky_details 2,10,1,11,0,50,50")                    ; Details -> Freaky Details
	(plug-in-gmic-qt 1 theImage glowingeyesLayer 1 0 "-v - -gcd_sharpen_tones 1,128,0,0")                            ; Details -> Sharpen Tones
	(plug-in-gmic-qt 1 theImage glowingeyesLayer 1 0 "-v - -gcd_sharpen_tones 1,128,0,0")                            ; Details -> Sharpen Tones
	(plug-in-gmic-qt 1 theImage glowingeyesLayer 1 0 "-v - -fx_color_presets 25,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,47,512,100,0,0,0,0,0,0,0,50,50,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0") ; Colors -> Color Presets -> Others -> Smooth Crome-Ish

	(define glowingeyesLayerOverlay (car (gimp-layer-copy glowingeyesLayer TRUE )))
	(gimp-image-insert-layer theImage glowingeyesLayerOverlay 0 0)
	(gimp-item-set-name glowingeyesLayerOverlay "Glowing Eyes (Overlay)")
	(gimp-layer-set-mode glowingeyesLayerOverlay LAYER-MODE-HSV-VALUE)
	(gimp-drawable-levels glowingeyesLayerOverlay HISTOGRAM-VALUE 0.1 0.9 TRUE 1 0 1 TRUE)

	(define glowingeyesLayerFinal (car (gimp-image-merge-down theImage glowingeyesLayerOverlay EXPAND-AS-NECESSARY)))

	(gimp-layer-set-opacity glowingeyesLayerFinal 45)

	;Ensure the updated image is displayed now
	(gimp-displays-flush)

	; stop undo
	(gimp-image-undo-group-end theImage)

) ;end define

(script-fu-register "gestreift-script-fu-eye-glow"
	_"Create Glowing Eyes ..."
	"This script combines serveral tools out of G'MIC to create a glowing eyes effect. Copy the pupil of an eye into a new layer and start 'Create Glowing Eyes ...'. Do not forget to adjust the opacity of the new layer!"
	"Andreas"
	"andreas@gestreift.net"
	"March 2022"
	"*"
	SF-IMAGE		"Image"     0
	SF-DRAWABLE		"Drawable"  0
)

(script-fu-menu-register "gestreift-script-fu-eye-glow"
                         "<Image>/Filters/gestreift.net")
