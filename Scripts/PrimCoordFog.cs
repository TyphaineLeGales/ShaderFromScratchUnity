using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class PrimCoordFog : MonoBehaviour
{
     Vector3 _primPos;
     float _primScale;
     
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
         _primPos = GetComponent<Transform>().position;
        this.GetComponent<Renderer>().sharedMaterial.SetVector("_FogCentre", _primPos); 
        _primScale = GetComponent<Transform>().localScale.x/2 ;
         this.GetComponent<Renderer>().sharedMaterial.SetFloat("_FogRadius", _primScale); 
        
    }
}
