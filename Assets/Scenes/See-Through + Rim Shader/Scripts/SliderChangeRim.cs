using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SliderChangeRim : MonoBehaviour {

    // Use this for initialization
    Material mat;
    public Slider slider;

	void Start () {
        mat = GetComponent<MeshRenderer>().material;

	}
	
	// Update is called once per frame
	void Update () {
		
	}

    public void ChangeRimFactor()
    {
        mat.SetFloat("_RimPow", slider.value);
    }
}
