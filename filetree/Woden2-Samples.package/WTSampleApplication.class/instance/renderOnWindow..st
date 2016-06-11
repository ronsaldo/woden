rendering
renderOnWindow: aWindow
	| frameIndex commandList commandAllocator cameraUniformBinding objectStateBinding globalLightingStateBinding |
	frameIndex := engine newFrame.
	
	self
		updateProjectionMatrixFor: aWindow;
		updateObjectStates;
		updateLightingState.
	
	commandList := commandLists at: frameIndex.
	commandAllocator := commandAllocators at: frameIndex.
	commandAllocator reset.
	
	cameraUniformBinding := cameraUniformBindings at: frameIndex.
	objectStateBinding := objectStateBindings at: frameIndex.
	globalLightingStateBinding := globalLightingStateBindings at: frameIndex.
	
	commandList withPipelineState: pipelineState rebuild: [ :builder |
		builder
			setShaderSignature: shaderSignature handle;
			beginRenderPass: mainRenderPass validHandle framebuffer: aWindow currentFramebuffer bundle_content: false asBit;
			
			setViewport: 0 y: 0 w: aWindow screenWidth h: aWindow screenHeight;
			setScissor: 0 y: 0 w: aWindow screenWidth h: aWindow screenHeight;
			
			useShaderResources: cameraUniformBinding validHandle;
			useShaderResources: objectStateBinding validHandle;
			useShaderResources: globalLightingStateBinding validHandle.
			
		mesh renderOn: builder mode: #forward.
		builder		
			endRenderPass.
	].
	
	engine graphicsQueue
		addCommandList: commandList validHandle