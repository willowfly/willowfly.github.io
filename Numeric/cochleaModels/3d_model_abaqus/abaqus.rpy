# -*- coding: mbcs -*-
#
# Abaqus/CAE Release 6.13-1 replay file
# Internal Version: 2013_05_16-10.28.56 126354
# Run by RenLi on Tue Jun 25 22:36:53 2019
#

# from driverUtils import executeOnCaeGraphicsStartup
# executeOnCaeGraphicsStartup()
#: Executing "onCaeGraphicsStartup()" in the site directory ...
#: Abaqus Error: 
#: This error may have occurred due to a change to the Abaqus Scripting
#: Interface. Please see the Abaqus Scripting Manual for the details of
#: these changes. Also see the "Example environment files" section of 
#: the Abaqus Site Guide for up-to-date examples of common tasks in the
#: environment file.
#: Execution of "onCaeGraphicsStartup()" in the site directory failed.
from abaqus import *
from abaqusConstants import *
session.Viewport(name='Viewport: 1', origin=(0.0, 0.0), width=158.27197265625, 
    height=69.0260391235352)
session.viewports['Viewport: 1'].makeCurrent()
session.viewports['Viewport: 1'].maximize()
from caeModules import *
from driverUtils import executeOnCaeStartup
executeOnCaeStartup()
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=ON)
a = mdb.models['Model-1'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
mdb.ModelFromInputFile(name='model01-ac-spiral', 
    inputFileName='C:/Users/RenLi/__matlab/__model_cochlea/3d_model_abaqus/MODEL01/model01-ac-spiral.inp')
#: The model "model01-ac-spiral" has been created.
#: WARNING: Empty part PART1. This occurred while reading keyword options within part definition. 
#: WARNING: Part instance INST1 references an empty part. A new part named INST1 will be created from the mesh data in part instance INST1. 
#: The part "INST1" has been imported from the input file.
#: 
#: WARNING: The following keywords/parameters are not yet supported by the input file reader:
#: ---------------------------------------------------------------------------------
#: *NSET, ELSET
#: *PREPRINT
#: The model "model01-ac-spiral" has been imported from an input file. 
#: Please scroll up to check for error and warning messages.
session.viewports['Viewport: 1'].assemblyDisplay.setValues(
    optimizationTasks=OFF, geometricRestrictions=OFF, stopConditions=OFF)
a = mdb.models['model01-ac-spiral'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].view.setValues(nearPlane=70.6048, 
    farPlane=109.32, width=38.3528, height=16.4027, cameraUpVector=(-0.810293, 
    0.514149, -0.281206), cameraTarget=(17.2765, -1.00354, -0.622944))
session.viewports['Viewport: 1'].view.setValues(nearPlane=68.959, 
    farPlane=113.107, width=37.4588, height=16.0204, cameraPosition=(83.8547, 
    -22.6409, 55.8785), cameraUpVector=(-0.25874, 0.955727, 0.140144), 
    cameraTarget=(17.2765, -1.00355, -0.622944))
session.viewports['Viewport: 1'].view.setValues(nearPlane=69.1034, 
    farPlane=112.963, width=37.5373, height=16.0539, cameraPosition=(83.8547, 
    -22.6409, 55.8785), cameraUpVector=(-0.567419, 0.713466, 0.4111), 
    cameraTarget=(17.2765, -1.00355, -0.622944))
session.viewports['Viewport: 1'].view.setValues(nearPlane=70.5082, 
    farPlane=111.558, width=28.714, height=12.2804)
session.viewports['Viewport: 1'].view.setValues(nearPlane=70.428, 
    farPlane=111.638, width=28.6813, height=12.2664, viewOffsetX=-3.07179, 
    viewOffsetY=4.68911)
session.viewports['Viewport: 1'].view.setValues(nearPlane=73.0852, 
    farPlane=108.981, width=11.3066, height=4.8356, viewOffsetX=-3.18769, 
    viewOffsetY=4.86603)
session.viewports['Viewport: 1'].view.setValues(nearPlane=70.685, 
    farPlane=108.732, width=10.9353, height=4.6768, cameraPosition=(88.008, 
    -41.1384, 33.3768), cameraUpVector=(-0.526733, 0.420623, 0.738667), 
    cameraTarget=(16.8166, 1.66263, -1.16453), viewOffsetX=-3.083, 
    viewOffsetY=4.70622)
session.viewports['Viewport: 1'].view.setValues(nearPlane=70.7378, 
    farPlane=108.679, width=10.9435, height=4.6803, viewOffsetX=-3.4285, 
    viewOffsetY=2.73908)
session.viewports['Viewport: 1'].view.setValues(nearPlane=71.2992, 
    farPlane=108.186, width=11.0304, height=4.71746, cameraPosition=(85.7596, 
    -47.0516, 30.3258), cameraUpVector=(-0.550841, 0.323859, 0.769213), 
    cameraTarget=(17.0311, 2.07812, -0.591755), viewOffsetX=-3.45571, 
    viewOffsetY=2.76082)
session.viewports['Viewport: 1'].view.setValues(nearPlane=71.2865, 
    farPlane=108.198, width=11.0284, height=4.71664, viewOffsetX=-5.79782, 
    viewOffsetY=3.96888)
session.viewports['Viewport: 1'].view.setValues(nearPlane=71.7904, 
    farPlane=107.694, width=7.58073, height=3.24212, viewOffsetX=-6.15552, 
    viewOffsetY=3.80703)
session.viewports['Viewport: 1'].view.setValues(nearPlane=72.1943, 
    farPlane=107.29, width=4.98001, height=2.12985, viewOffsetX=-6.19015, 
    viewOffsetY=3.82845)
session.viewports['Viewport: 1'].view.setValues(nearPlane=72.1929, 
    farPlane=107.292, width=4.96223, height=2.12225, viewOffsetX=-6.19003, 
    viewOffsetY=3.82838)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(interactions=ON, 
    constraints=ON, connectors=ON, engineeringFeatures=ON)
session.viewports['Viewport: 1'].view.setValues(nearPlane=72.2512, 
    farPlane=107.233, width=4.57541, height=1.95681, viewOffsetX=-6.19503, 
    viewOffsetY=3.83147)
session.viewports['Viewport: 1'].view.setValues(nearPlane=72.2507, 
    farPlane=107.234, width=4.57538, height=1.9568, cameraPosition=(85.753, 
    -46.5232, 31.18), cameraUpVector=(-0.607918, 0.23686, 0.757847), 
    cameraTarget=(17.0245, 2.60649, 0.262471), viewOffsetX=-6.19498, 
    viewOffsetY=3.83144)
session.viewports['Viewport: 1'].view.setValues(nearPlane=72.3792, 
    farPlane=107.105, width=3.67767, height=1.57287, viewOffsetX=-6.2867, 
    viewOffsetY=3.84024)
session.viewports['Viewport: 1'].view.setValues(nearPlane=70.9337, 
    farPlane=108.551, width=13.1383, height=5.619, viewOffsetX=-6.16114, 
    viewOffsetY=3.76354)
session.viewports['Viewport: 1'].view.setValues(nearPlane=70.9701, 
    farPlane=108.514, width=13.1451, height=5.62188, viewOffsetX=-6.1643, 
    viewOffsetY=3.76547)
session.viewports['Viewport: 1'].view.setValues(nearPlane=70.9701, 
    farPlane=108.514, width=13.1451, height=5.6219, viewOffsetX=-6.1643, 
    viewOffsetY=3.76547)
session.viewports['Viewport: 1'].view.setValues(nearPlane=70.9701, 
    farPlane=108.514, width=13.1451, height=5.6219, viewOffsetX=-6.1643, 
    viewOffsetY=3.76547)
session.viewports['Viewport: 1'].view.setValues(nearPlane=67.0838, 
    farPlane=112.401, width=37.1406, height=15.8843, viewOffsetX=-5.82674, 
    viewOffsetY=3.55927)
session.viewports['Viewport: 1'].view.setValues(nearPlane=66.9868, 
    farPlane=112.498, width=39.5687, height=16.9228, viewOffsetX=-5.81831, 
    viewOffsetY=3.55412)
session.viewports['Viewport: 1'].view.setValues(nearPlane=86.1677, 
    farPlane=103.039, width=50.8989, height=21.7684, cameraPosition=(15.8788, 
    -89.2976, 31.7445), cameraUpVector=(-0.125084, 0.644552, 0.754259), 
    cameraTarget=(19.729, -5.12956, 0.214506), viewOffsetX=-7.48431, 
    viewOffsetY=4.5718)
session.viewports['Viewport: 1'].view.setValues(nearPlane=75.6834, 
    farPlane=119.313, width=44.7059, height=19.1198, cameraPosition=(-42.2133, 
    -69.9121, 36.4876), cameraUpVector=(0.128752, 0.738255, 0.66212), 
    cameraTarget=(14.8721, -9.06758, 2.83614), viewOffsetX=-6.57367, 
    viewOffsetY=4.01554)
