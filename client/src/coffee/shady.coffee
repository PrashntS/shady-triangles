DEFAULT_OBJECT = 'toutatis'
container = undefined
stats = undefined
camera = undefined
scene = undefined
renderer = undefined
manager = undefined
controls = undefined
directionalLight = undefined
asteroidMaterials = undefined
autoScale = true
embeddedMode = false
mouseX = 0
mouseY = 0
windowHalfX = window.innerWidth / 2
windowHalfY = window.innerHeight / 2

initSelect = ->
  i = 0
  $('<option>').html(DEFAULT_OBJECT).appendTo $('#obj')

  $('#obj').val DEFAULT_OBJECT
  $('#obj').change ->
    scene.remove window.obj
    name = $(this).val()
    loadModel name
    window.location.hash = '#' + name

loadModel = (name) ->
  loader = new (THREE.OBJLoader)(manager)
  asteroidMaterials = []
  loader.load '/obj/' + name + '.txt', (object) ->
    object.traverse (child) ->
      if child instanceof THREE.Mesh
        material = new (THREE.MeshLambertMaterial)(color: 0xcccccc)
        child.material = material
        child.geometry.computeFaceNormals()
        child.geometry.computeVertexNormals()
        child.geometry.computeBoundingBox()
        asteroidMaterials.push material
    object.rotation.x = 20 * Math.PI / 180
    object.rotation.z = 20 * Math.PI / 180
    scene.add object
    window.obj = object
    if autoScale
      zoomToFitObject()

zoomToFitObject = ->
  boundingBox = obj.children[0].geometry.boundingBox
  camera.position.x = boundingBox.max.x * 3.7
  camera.position.y = boundingBox.max.y * 3.7
  camera.position.z = boundingBox.max.z * 3.7

createGui = ->
  unless /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
    gui = new (dat.GUI)
    uiOptions =
      'Wireframe': false
      'Autoscale': true
      'Zoom to fit': zoomToFitObject
    window.uiOptions = uiOptions
    gui.add(uiOptions, 'Wireframe').onChange (value) ->
      asteroidMaterials.map (mat) ->
        mat.wireframe = value
    gui.add(uiOptions, 'Autoscale').onChange (value) ->
      autoScale = value
    gui.add uiOptions, 'Zoom to fit'

init = ->
  container = document.createElement('div')
  document.body.appendChild container
  camera = new (THREE.PerspectiveCamera)(45, window.innerWidth / window.innerHeight, 1, 2000)
  camera.position.z = 1300
  # scene
  scene = new (THREE.Scene)
  # add subtle ambient lighting
  ambientLight = new (THREE.AmbientLight)(0x333333)
  scene.add ambientLight
  # directional lighting
  #var directionalLight = new THREE.DirectionalLight(0x855E42);
  #directionalLight = new THREE.DirectionalLight(0xeeeec4);
  directionalLight = new (THREE.DirectionalLight)(0xE8E8F0)
  directionalLight.position.set(10000, 10000, 10000).normalize()
  scene.add directionalLight
  directionalLight2 = new (THREE.DirectionalLight)(0x333333)
  directionalLight2.position.set(-10000, -10000, -10000).normalize()
  scene.add directionalLight2
  # loaders
  manager = new (THREE.LoadingManager)

  manager.onProgress = (item, loaded, total) ->
    console.log item, loaded, total

  # UI stuff
  if !embeddedMode
    initSelect()
    createGui()
    document.getElementById('info').style.display = 'block'
  # asteroid texture
  texture = new (THREE.Texture)
  loader = new (THREE.ImageLoader)(manager)
  # model
  loadModel DEFAULT_OBJECT
  renderer = new (THREE.WebGLRenderer)
  renderer.setSize window.innerWidth, window.innerHeight
  container.appendChild renderer.domElement
  controls = new (THREE.TrackballControls)(camera, renderer.domElement)
  controls.rotateSpeed = 0.5
  controls.dynamicDampingFactor = 0.5
  window.addEventListener 'resize', onWindowResize, false

onWindowResize = ->
  windowHalfX = window.innerWidth / 2
  windowHalfY = window.innerHeight / 2
  camera.aspect = window.innerWidth / window.innerHeight
  camera.updateProjectionMatrix()
  renderer.setSize window.innerWidth, window.innerHeight

animate = ->
  requestAnimationFrame animate
  controls.update camera
  render()

render = ->
  if typeof obj != 'undefined'
    obj.rotation.x += 0.2 * Math.PI / 180
    obj.rotation.x %= 360
  camera.lookAt scene.position
  renderer.render scene, camera

getParameterByName = (name) ->
  name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]')
  regex = new RegExp('[\\?&]' + name + '=([^&#]*)')
  results = regex.exec(location.search)
  if results == null then '' else decodeURIComponent(results[1].replace(/\+/g, ' '))

init()
animate()
