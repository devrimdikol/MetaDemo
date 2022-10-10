using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationPlayer : MonoBehaviour
{

    public string[] clips;
    public float duration;
    public Animator animator;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown("1"))
            animator.CrossFade(clips[0], duration);
        if (Input.GetKeyDown("2"))
            animator.CrossFade(clips[1], duration);
        if (Input.GetKeyDown("3"))
            animator.CrossFade(clips[2], duration);
        if (Input.GetKeyDown("4"))
            animator.CrossFade(clips[3], duration);
        if (Input.GetKeyDown("5"))
            animator.CrossFade(clips[4], duration);
        if (Input.GetKeyDown("6"))
            animator.CrossFade(clips[5], duration);
        if (Input.GetKeyDown("7"))
            animator.CrossFade(clips[6], duration);
        if (Input.GetKeyDown("8"))
            animator.CrossFade(clips[7], duration);
        if (Input.GetKeyDown("9"))
            animator.CrossFade(clips[8], duration);
        if (Input.GetKeyDown("0"))
            animator.CrossFade(clips[9], duration);

    }
}
