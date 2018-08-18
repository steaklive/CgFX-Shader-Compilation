using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SliderInterferenceControlScript : MonoBehaviour {

    public Slider sliderReflectionSaturation;
    public Slider sliderRimEffect;
    public Slider sliderNumberOfMultipliers;
    public Slider sliderIndexOfRefraction;
    public Slider sliderNoiseMagnifier;

    MeshRenderer[] rend;

    // Use this for initialization
    void Start () {
        rend = GetComponentsInChildren<MeshRenderer>();
    }

    // Update is called once per frame
    void Update () {
		
	}

    public void ChangeReflectionSaturation()
    {
        foreach (var r in rend)
        {
            r.material.SetFloat("_Saturation", sliderReflectionSaturation.value);
        }
    }
    public void ChangeRimEffect()
    {
        foreach (var r in rend)
        {
            r.material.SetFloat("_RimEffect", sliderRimEffect.value);
        }
    }
    public void ChangeNumberOfMultipliers()
    {
        foreach (var r in rend)
        {
            r.material.SetFloat("_Numbers", sliderNumberOfMultipliers.value);
        }
    }
    public void ChangeIndexOfRefraction()
    {
        foreach (var r in rend)
        {
            r.material.SetFloat("_RefractionIndex", sliderIndexOfRefraction.value);
        }
    }
    public void ChangeNoiseMagnifier()
    {
        foreach (var r in rend)
        {
            r.material.SetFloat("_NoiseMag", sliderNoiseMagnifier.value);
        }
    }

}
