using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SliderChangeOutline : MonoBehaviour {

    MeshRenderer rend;
    public Slider slider;

    void Start()
    {
        rend = GetComponent<MeshRenderer>();
    }

    public void ChangeOutlineFactor()
    {
        rend.material.SetFloat("_DepthFactor", slider.value);
    }
}
