//**********************************************************************//
//                                                                      //
// This script manages the list of all available scenes in the build.   //
//                                                                      //
//**********************************************************************//

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;
#endif

using UnityEngine.SceneManagement;

public class ChangeScenes : MonoBehaviour {


    private List<string> _sceneNames = new List<string>();

    private string _previousScene = null;
    private string _nextScene = null;
    private string _currentScene = null;


    private void Start()
    {
        FillScenesList();
        AssignPrevAndNextScenes();
    }

    private void FillScenesList()
    {
        #if UNITY_EDITOR
        // putting scenes' paths from Build Settings into the list
        foreach (EditorBuildSettingsScene scene in EditorBuildSettings.scenes)
        {
            if (scene.enabled)
            {
                // there's no in-build way for getting a name of the scene (only path)
                // that's why we do some string manipulations...
                string name = scene.path.Substring(scene.path.LastIndexOf('/') + 1);
                name = name.Substring(0, name.Length - 6);

                _sceneNames.Add(name);
            }
        }
        #else
            _sceneNames.Add("InterferenceScene");
            _sceneNames.Add("OrenNayarScene");
            _sceneNames.Add("SimpleSnowScene");
            _sceneNames.Add("FastSubsurfaceScatteringScene");
            _sceneNames.Add("SeeThroughRimScene");
            _sceneNames.Add("IntersectionOutlineDepthScene");
            _sceneNames.Add("ShellRenderingScene");
            _sceneNames.Add("DeformableSurfaceTessellationScene");
        #endif
    }

    private void AssignPrevAndNextScenes()
    {
        _currentScene = SceneManager.GetActiveScene().name;

        //simply filling the previous and the next scenes of the current level
        int index = _sceneNames.IndexOf(_currentScene);
        if (index != -1)
        {
            if (index == _sceneNames.Count - 1) _nextScene = _sceneNames[0];
            else _nextScene = _sceneNames[index + 1];

            if (index == 0) _previousScene = _sceneNames[_sceneNames.Count - 1];
            else _previousScene = _sceneNames[index - 1];

        }
    }

    private void Update()
    {
        if (Input.GetKey(KeyCode.Escape)) Application.Quit();
    }

    // Attach this method to the right arrow button
    public void NextScene()
    {
        if(_nextScene!=null) SceneManager.LoadScene(_nextScene);
    }

    // Attach this method to the left arrow button
    public void PreviousScene()
    {
        if (_previousScene!=null) SceneManager.LoadScene(_previousScene);
    }
}
