(function() {
  var DEFAULT_OBJECT, animate, asteroidMaterials, autoScale, camera, container, controls, createGui, directionalLight, embeddedMode, getParameterByName, init, initSelect, loadModel, manager, mouseX, mouseY, onWindowResize, render, renderer, scene, stats, windowHalfX, windowHalfY, zoomToFitObject;

  DEFAULT_OBJECT = 'toutatis';

  container = void 0;

  stats = void 0;

  camera = void 0;

  scene = void 0;

  renderer = void 0;

  manager = void 0;

  controls = void 0;

  directionalLight = void 0;

  asteroidMaterials = void 0;

  autoScale = true;

  embeddedMode = false;

  mouseX = 0;

  mouseY = 0;

  windowHalfX = window.innerWidth / 2;

  windowHalfY = window.innerHeight / 2;

  initSelect = function() {
    var i;
    i = 0;
    $('<option>').html(DEFAULT_OBJECT).appendTo($('#obj'));
    $('#obj').val(DEFAULT_OBJECT);
    return $('#obj').change(function() {
      var name;
      scene.remove(window.obj);
      name = $(this).val();
      loadModel(name);
      return window.location.hash = '#' + name;
    });
  };

  loadModel = function(name) {
    var loader;
    loader = new THREE.OBJLoader(manager);
    asteroidMaterials = [];
    return loader.load('/obj/' + name + '.txt', function(object) {
      object.traverse(function(child) {
        var material;
        if (child instanceof THREE.Mesh) {
          material = new THREE.MeshLambertMaterial({
            color: 0xcccccc
          });
          child.material = material;
          child.geometry.computeFaceNormals();
          child.geometry.computeVertexNormals();
          child.geometry.computeBoundingBox();
          return asteroidMaterials.push(material);
        }
      });
      object.rotation.x = 20 * Math.PI / 180;
      object.rotation.z = 20 * Math.PI / 180;
      scene.add(object);
      window.obj = object;
      if (autoScale) {
        return zoomToFitObject();
      }
    });
  };

  zoomToFitObject = function() {
    var boundingBox;
    boundingBox = obj.children[0].geometry.boundingBox;
    camera.position.x = boundingBox.max.x * 3.7;
    camera.position.y = boundingBox.max.y * 3.7;
    return camera.position.z = boundingBox.max.z * 3.7;
  };

  createGui = function() {
    var gui, uiOptions;
    if (!/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
      gui = new dat.GUI;
      uiOptions = {
        'Wireframe': false,
        'Autoscale': true,
        'Zoom to fit': zoomToFitObject
      };
      window.uiOptions = uiOptions;
      gui.add(uiOptions, 'Wireframe').onChange(function(value) {
        return asteroidMaterials.map(function(mat) {
          return mat.wireframe = value;
        });
      });
      gui.add(uiOptions, 'Autoscale').onChange(function(value) {
        return autoScale = value;
      });
      return gui.add(uiOptions, 'Zoom to fit');
    }
  };

  init = function() {
    var ambientLight, directionalLight2, loader, texture;
    container = document.createElement('div');
    document.body.appendChild(container);
    camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 1, 2000);
    camera.position.z = 1300;
    scene = new THREE.Scene;
    ambientLight = new THREE.AmbientLight(0x333333);
    scene.add(ambientLight);
    directionalLight = new THREE.DirectionalLight(0xE8E8F0);
    directionalLight.position.set(10000, 10000, 10000).normalize();
    scene.add(directionalLight);
    directionalLight2 = new THREE.DirectionalLight(0x333333);
    directionalLight2.position.set(-10000, -10000, -10000).normalize();
    scene.add(directionalLight2);
    manager = new THREE.LoadingManager;
    manager.onProgress = function(item, loaded, total) {
      return console.log(item, loaded, total);
    };
    if (!embeddedMode) {
      initSelect();
      createGui();
      document.getElementById('info').style.display = 'block';
    }
    texture = new THREE.Texture;
    loader = new THREE.ImageLoader(manager);
    loadModel(DEFAULT_OBJECT);
    renderer = new THREE.WebGLRenderer;
    renderer.setSize(window.innerWidth, window.innerHeight);
    container.appendChild(renderer.domElement);
    controls = new THREE.TrackballControls(camera, renderer.domElement);
    controls.rotateSpeed = 0.5;
    controls.dynamicDampingFactor = 0.5;
    return window.addEventListener('resize', onWindowResize, false);
  };

  onWindowResize = function() {
    windowHalfX = window.innerWidth / 2;
    windowHalfY = window.innerHeight / 2;
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    return renderer.setSize(window.innerWidth, window.innerHeight);
  };

  animate = function() {
    requestAnimationFrame(animate);
    controls.update(camera);
    return render();
  };

  render = function() {
    if (typeof obj !== 'undefined') {
      obj.rotation.x += 0.2 * Math.PI / 180;
      obj.rotation.x %= 360;
    }
    camera.lookAt(scene.position);
    return renderer.render(scene, camera);
  };

  getParameterByName = function(name) {
    var regex, results;
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
    regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
    results = regex.exec(location.search);
    if (results === null) {
      return '';
    } else {
      return decodeURIComponent(results[1].replace(/\+/g, ' '));
    }
  };

  init();

  animate();

}).call(this);
