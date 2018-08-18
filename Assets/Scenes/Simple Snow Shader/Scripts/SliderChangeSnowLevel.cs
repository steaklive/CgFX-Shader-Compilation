using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SliderChangeSnowLevel : MonoBehaviour {

    MeshRenderer[] rend;
    public Slider slider;

    void Start()
    {
        rend = GetComponentsInChildren<MeshRenderer>();
    }

    public void ChangeSnow()
    {
        foreach (var r in rend)
        {
            r.material.SetFloat("_Snow", slider.value);
        }
    }
}
