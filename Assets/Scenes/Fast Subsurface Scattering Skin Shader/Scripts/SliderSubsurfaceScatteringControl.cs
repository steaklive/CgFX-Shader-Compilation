using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SliderSubsurfaceScatteringControl : MonoBehaviour {

    public Slider sliderDistortion;
    public Slider sliderPower;
    public Slider sliderScale;
    public Slider sliderAttenuation;
    public Slider sliderAmbient;

    MeshRenderer[] rend;


    // Use this for initialization
    void Start () {
        rend = GetComponentsInChildren<MeshRenderer>();

    }

    // Update is called once per frame
    void Update () {
		
	}

    public void ChangeDistortion()
    {
        foreach (var r in rend)
        {
            r.material.SetFloat("_DeltaDist", sliderDistortion.value);
        }
    }
    public void ChangePower()
    {
        foreach (var r in rend)
        {
            r.material.SetFloat("_Power", sliderPower.value);
        }
    }
    public void ChangeScale()
    {
        foreach (var r in rend)
        {
            r.material.SetFloat("_Scale", sliderScale.value);
        }
    }
    public void ChangeAttenuation()
    {
        foreach (var r in rend)
        {
            r.material.SetFloat("_Attenuation", sliderAttenuation.value);
        }
    }
    public void ChangeAmbient()
    {
        foreach (var r in rend)
        {
            r.material.SetFloat("_Ambient", sliderAmbient.value);
        }
    }
}
