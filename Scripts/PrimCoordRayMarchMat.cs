using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PrimCoordRayMarchMat : MonoBehaviour
{
    // Start is called before the first frame update
     Vector3 _primPos;

    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        _primPos = GetComponent<Transform>().position;
        Debug.Log(this.GetComponent<Renderer>().sharedMaterial.GetVector("_primitivePos"));
        Debug.Log(_primPos);
        this.GetComponent<Renderer>().sharedMaterial.SetVector(" _primitivePos", _primPos); 
    }
}
