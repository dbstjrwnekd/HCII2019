private var color:Color = Color.blue;

function Start () {
	GetComponent.<Renderer>().material.color = color;
}