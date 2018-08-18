using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SliderChangeSigma : MonoBehaviour
{

    // Use this for initialization
    MeshRenderer[] rend;
    public Slider slider;

    void Start()
    {
        rend = GetComponentsInChildren<MeshRenderer>();
    }

    public void ChangeSigmaFactor()
    {
        foreach (var r in rend)
        {
            r.material.SetFloat("_Roughness", slider.value);
        }
    }
}

