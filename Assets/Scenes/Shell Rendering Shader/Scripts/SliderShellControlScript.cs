using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SliderShellControlScript : MonoBehaviour {

    public GameObject targetObject;

    public Slider sliderFurLength;
    public Slider sliderGravityStrength;
    public Slider sliderWindFrequency;
    public Slider sliderForceX;
    public Slider sliderForceY;
    //public Slider sliderForceZ;

    private Material _furMaterial;

    // Use this for initialization
    void Start () {
        _furMaterial = targetObject.GetComponent<Renderer>().material;
    }
	
	// Update is called once per frame
	void Update () {

        ChangeLength();
        ChangeGravity();
        ChangeForceProperties();

    }

    void ChangeLength()
    {
        _furMaterial.SetFloat("_FurLength", sliderFurLength.value);
    }

    void ChangeGravity()
    {
        _furMaterial.SetFloat("_GravityStrength", sliderGravityStrength.value);
    }

    void ChangeForceProperties()
    {


        float windValueX = Mathf.Sin(Time.time * sliderWindFrequency.value);
        float windValueY = Mathf.Sin(Time.time * sliderWindFrequency.value);
        float windValueZ = Mathf.Sin(Time.time * sliderWindFrequency.value);

        _furMaterial.SetVector("_Gravity", new Vector4(
                                        sliderForceX.value * windValueX,
                                        sliderForceY.value * windValueY,
                                        0 * windValueZ,
                                        0));
    }


}
