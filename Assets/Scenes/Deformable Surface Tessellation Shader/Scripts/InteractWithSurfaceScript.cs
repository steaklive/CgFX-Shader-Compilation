//*************************************************************************************//
//                                                                                     //
// This script draws a displacement texture by raycasting from the objects position    //
//                                                                                     //
//*************************************************************************************//

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InteractWithSurfaceScript : MonoBehaviour {

    public Shader shader;
    public GameObject surface;
    public Transform objTransform;

    private RenderTexture _dispTexture;
    private Material _mainMaterial;
    private Material _secondMaterial;

    private RaycastHit _hit;
    private int _layer;

    // Use this for initialization
    void Start () {

        _secondMaterial = new Material(shader);

        _layer = LayerMask.GetMask("DeformableSurface");
        _mainMaterial = surface.GetComponent<MeshRenderer>().material;

        _dispTexture = new RenderTexture(2048, 2048, 0, RenderTextureFormat.ARGBFloat);
        _mainMaterial.SetTexture("_DispTex", _dispTexture);
    }
	
	// Update is called once per frame
	void Update () {
        if (Physics.Raycast(objTransform.position, -Vector3.up, out _hit, 1f, _layer))
        {
            _secondMaterial.SetVector("_Coordinate", new Vector4(_hit.textureCoord.x, _hit.textureCoord.y, 0, 0));
            RenderTexture tmp = RenderTexture.GetTemporary(_dispTexture.width, _dispTexture.height, 0, RenderTextureFormat.ARGBFloat);
            Graphics.Blit(_dispTexture, tmp);
            Graphics.Blit(tmp, _dispTexture, _secondMaterial);

            RenderTexture.ReleaseTemporary(tmp);
        }
    }
}
