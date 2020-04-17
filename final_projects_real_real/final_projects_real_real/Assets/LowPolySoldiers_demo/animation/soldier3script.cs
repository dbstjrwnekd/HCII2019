using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class soldier3script : MonoBehaviour {
    private string objectName = "back";

    static Animator anim;
    static AudioSource sound;
    public float speed = 0.0f;
    public float rotationSpeed = 0.0f;
    static int num_frame = 0;

    enum State
    {
        Idle,
        Hit
    }

    State currentState;

    // Use this for initialization
    void Start()
    {
        currentState = State.Idle;
        NextState();

        //float rotation = Input.GetAxis("Horizontal") * rotationSpeed;
       // rotation = rotation - 90;
        transform.Rotate(0, 90, 0);

        anim = GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        num_frame += 1;

        if (num_frame < 1100)
        {
            sound = GetComponent<AudioSource>();
            sound.volume = num_frame/1100.0f;
            speed = 3.0f;
        }
        else if (num_frame < 2800)
        {
            speed = 0.0f;
            sound.volume = 0;
            anim.SetBool("isrunning", false);
        }
        else if (num_frame >=2800 && num_frame <2830)
        {
            rotationSpeed = -3.0f;
            
            float rotation = Input.GetAxis("Horizontal") * rotationSpeed;
            rotation = rotation * Time.deltaTime + rotationSpeed;
            transform.Rotate(0, -rotation, 0);

            speed = 0.03f;
            sound.volume = sound.volume=2800.0f/num_frame;
        }
        else if(num_frame < 5300)
        {
            speed = 3.0f;
            sound.volume = sound.volume = 2500.0f / num_frame;
        }
        else
        {
            speed = 0;
            sound.volume = 0;
        }

        float transition = Input.GetAxis("Vertical") + speed;
        transition = transition * Time.deltaTime;

        transform.Translate(0, 0, transition);

        if (speed != 0.0f)
        {
            anim.SetBool("isrunning", true);
        }
        else
        {
            anim.SetBool("isrunning", false);
        }

    }

    public string Hit()
    {
        if (currentState == State.Hit)
        {
            return objectName;
        }
        else
        {
            currentState = State.Hit;
            return objectName;
        }

    }

    IEnumerator IdleState()
    {
        this.gameObject.transform.rotation = Quaternion.identity;

        while (currentState == State.Idle)
        {
            yield return null;
        }

        NextState();
    }


    IEnumerator HitState()
    {

        float hitTime = 0.5f;


        while (currentState == State.Hit)
        {
            yield return null;

            if (hitTime <= 0)
            {
                this.currentState = State.Idle;
            }
            hitTime -= Time.deltaTime;
        }

        NextState();
    }

    void NextState()
    {
        switch (currentState)
        {
            case State.Idle:
                StartCoroutine(IdleState());
                break;
            case State.Hit:
                StartCoroutine(HitState());
                break;
        }
    }
}
