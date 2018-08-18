using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SliderSurfaceTesselationControlScript : MonoBehaviour {

    public GameObject targetObject;

    public Slider sliderTesselation;
    public Slider sliderDisplacement;

    private Material _surfaceTessellationMaterial;
    // Use this for initialization
    void Start () {
		_surfaceTessellationMaterial = targetObject.GetComponent<Renderer>().material;
    }
	
	// Update is called once per frame
	void Update () {
        ChangeDisp();
        ChangeTess();
	}

    void ChangeTess()
    {
        _surfaceTessellationMaterial.SetFloat("_Tess", sliderTesselation.value);
    }

    void ChangeDisp()
    {
        _surfaceTessellationMaterial.SetFloat("_Displacement", sliderDisplacement.value);
    }
}
