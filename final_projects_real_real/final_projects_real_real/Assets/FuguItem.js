var url:String;
private var scale=1.2;

function OnMouseDown () {
	var stream = new WWW (url);
	var textmesh:TextMesh = transform.parent.gameObject.transform.Find("Text").GetComponent(TextMesh);
	while (!stream.isDone) {
		var percent:int = Mathf.Floor(stream.progress*100);
		textmesh.text = stream.progress.ToString("P");
		yield;
	}
	// Load it!
//	stream.LoadUnityWeb();
}

function OnMouseEnter() {
//	renderer.material.color = Color.yellow;
	transform.localScale *= scale;
}

function OnMouseExit() {
//	renderer.material.color = Color.white;
	transform.localScale /= scale;
}

function Update() {
	transform.LookAt(Camera.main.ScreenToWorldPoint(Vector3(Input.mousePosition.x,Input.mousePosition.y,5)));
}