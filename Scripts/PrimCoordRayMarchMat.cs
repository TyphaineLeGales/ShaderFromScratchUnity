using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[ExecuteInEditMode]
public class PrimCoordRayMarchMat : MonoBehaviour
{
     Vector3 _primPos;

    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        _primPos = GetComponent<Transform>().position;
       this.GetComponent<Renderer>().sharedMaterial.SetVector("_primitivePos", _primPos); 
    }
}
