special matrices
scaleX: xScale y: yScale z: zScale
	<argument: #(xScale yScale zScale) type: #float>
	<returnType: #(SelfType object)>
	<var: #zero type: #float>
	| zero |
	zero := 0.0 asNativeFloat.
	^ self 
		m11: xScale m12: zero negated m13: zero
		m21: zero m22: yScale m23: zero
		m31: zero m32: zero m33: zScale