import { cameraPicker } from '@kit.CameraKit';
import { camera } from '@kit.CameraKit';
import { BusinessError } from '@ohos.base';
import { hilog } from '@kit.PerformanceAnalysisKit'

@Entry
@Component
struct D0408Page4 {
  @State uri: Resource | string | undefined = undefined;
  private cameraPosition: Array<camera.CameraPosition> = [
    camera.CameraPosition.CAMERA_POSITION_UNSPECIFIED, camera.CameraPosition.CAMERA_POSITION_BACK,
    camera.CameraPosition.CAMERA_POSITION_FRONT
  ];
  private mediaType: Array<cameraPicker.PickerMediaType> = [
    cameraPicker.PickerMediaType.PHOTO, cameraPicker.PickerMediaType.VIDEO
  ];

  build() {
    Column() {
      Image(this.uri)
        .height(100)
        .alt($r('app.media.startIcon'))
      Button('拍照')
        .onClick(async () => {
          try {
            let pickerProfile: cameraPicker.PickerProfile = { cameraPosition: this.cameraPosition[1] };
            let pickerResult: cameraPicker.PickerResult = await cameraPicker.pick(getContext(this),
              [this.mediaType[0]], pickerProfile);
            this.uri = pickerResult.resultUri;
            hilog.info(0x0000, ' ', "the pick pickerResult is:" + JSON.stringify(pickerResult));
          } catch (error) {
            let err = error as BusinessError;
            hilog.error(0x0000, '', `the pick call failed. error code: ${err.code}`);
          }
        })
    }
    .width('100%')
  }
}