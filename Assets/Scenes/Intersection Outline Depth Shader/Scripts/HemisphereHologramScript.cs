//*************************************************************//
//                                                             //
// This script manages the dynamic scaling of the hemisphere   //
//                                                             //
//*************************************************************//

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HemisphereHologramScript : MonoBehaviour {

    [SerializeField]
    float _radius = 2f;

    private float _waitTime = 0.5f;

    // Use this for initialization
    void Start () {
        StartCoroutine(Scaling());
	}

    IEnumerator Scaling()
    {
        Vector3 destinationScale = new Vector3(2 * _radius, 2 * _radius, 2 * _radius);

        float timer = 0;

        while (true)
        {
           
            while (destinationScale.x > transform.localScale.x)
            {
                timer += Time.deltaTime;
                transform.localScale += new Vector3(1, 1, 1) * Time.deltaTime * 50;
                yield return null;
            }
            yield return new WaitForSeconds(_waitTime);
            timer = 0;

            while (1 < transform.localScale.x)
            {
                timer += Time.deltaTime;
                transform.localScale -= new Vector3(1, 1, 1) * Time.deltaTime * 50;
                yield return null;
            }
            timer = 0;
            yield return new WaitForSeconds(_waitTime);
        }
    }
}
