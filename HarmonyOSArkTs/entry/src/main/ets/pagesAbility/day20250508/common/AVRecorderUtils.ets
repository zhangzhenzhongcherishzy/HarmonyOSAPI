import { media } from '@kit.MediaKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo as fs } from '@kit.CoreFileKit';

export class AVRecordUtils {
  //1、创建变量用于承接AVRecorder对象 使用Promise或callback作为异步回调
  private avRecorder: media.AVRecorder | undefined = undefined;
  //2、音频录制选项 比特率 声道数量等
  private avProfile: media.AVRecorderProfile = {
    audioBitrate: 100000, // 音频比特率。
    audioChannels: 2, // 音频声道数。
    audioCodec: media.CodecMimeType.AUDIO_AAC, // 音频编码格式，当前支持ACC，MP3，G711MU。
    audioSampleRate: 48000, // 音频采样率。
    fileFormat: media.ContainerFormatType.CFT_MPEG_4A, // 封装格式，当前支持MP4，M4A，MP3，WAV。
  };
  //3、录制设置 输出文件路径等
  private avConfig: media.AVRecorderConfig = {
    audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC, // 音频输入源，这里设置为麦克风。
    profile: this.avProfile,
    url: 'fd://35', // 参考应用文件访问与管理开发示例新建并读写一个文件。
  };

  //4、注册audioRecorder回调函数
  setAudioRecorderCallback() {
    if (this.avRecorder != undefined) {
      // 状态机变化回调函数。
      this.avRecorder.on('stateChange', (state: media.AVRecorderState, reason: media.StateChangeReason) => {
        console.log(`录制音频的回调状态${state}`)
      })
      // 错误上报回调函数。
      this.avRecorder.on('error', (err: BusinessError) => {
        console.log(`音频录制出现错误，${JSON.stringify(err)}`)
      })
    }
  }

  //5、开始录制对应的流程
  async startRecordingProcess() {
    //5.1重置录制属性 清空录制信息
    if (this.avRecorder != undefined) {
      //销毁录制对象
      await this.avRecorder.release();
      //重置录制变量
      this.avRecorder = undefined;
    }
    //5.2创建AVRecorder实例，实例创建完成即进入idle状态
    this.avRecorder = await media.createAVRecorder();
    //5.3调用状态机回调
    this.setAudioRecorderCallback();

    //5.4获取录制文件fd赋予avConfig里的url
    //音频的录制文件保存在应用的沙箱文件系统中
    //获取到filesDir 路径的文件夹路径
    //首先，定义文件路径保存录音
    const path = getContext(this).filesDir + 'test-AV.wav'
    //fd:文件的描述符
    //fd:// 文件句柄，需要打开文件获取句柄 数字，类似于代号
    /*
   * 5.5以同步的方式打开文件，支持使用uri打开文件
   * path:打开文件应用的沙箱路径或者uri,使用uri作为入参时，仅支持打开文件
   * OpenMode.CREATE() 若文件不存在，则创建文件
   * */
    let file = fs.openSync(path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
    let fileFd = 'fd://' + file.fd
    this.avConfig.url = fileFd
    AlertDialog.show({
      message:'1、音频路径配置完成'
    })
    //6、配置录制参数完成准备工作
    await this.avRecorder.prepare(this.avConfig);
    //7、开始录制 受到麦克风权限的限制，如果未授权，则无法开始录制
    await this.avRecorder.start();
    AlertDialog.show({
      message:'2、开始录制'
    })
  }

  //8、暂停录制 封装为函数供事件调用
  async pauseRecordingProcess() {
    if (this.avRecorder != undefined && this.avRecorder.state === 'started') { // 仅在started状态下调用pause为合理状态切换。
      await this.avRecorder.pause();
    }
  }

  //9、恢复录制对应流程
  async resumeRecordingProcess() {
    if (this.avRecorder != undefined && this.avRecorder.state === 'paused') { // 仅在paused状态下调用resume为合理状态切换。
      await this.avRecorder.resume();
    }
  }

  //10、停止录制流程
  async stopRecordingProcess() {
    if (this.avRecorder != undefined) {
      //10.1停止录制
      if (this.avRecorder.state === 'started'
        || this.avRecorder.state === 'paused') { // 仅在started或者paused状态下调用stop为合理状态切换。
        await this.avRecorder.stop();
      }
      //10.2重置
      await this.avRecorder.reset();
      //10.3释放录制实例
      await this.avRecorder.release();
      this.avRecorder = undefined;
    }
  }

  // // 一个完整的【开始录制-暂停录制-恢复录制-停止录制】示例。
  // async audioRecorderDemo() {
  //   await this.startRecordingProcess(); // 开始录制。
  //   // 用户此处可以自行设置录制时长，例如通过设置休眠阻止代码执行。
  //   await this.pauseRecordingProcess(); //暂停录制。
  //   await this.resumeRecordingProcess(); // 恢复录制。
  //   await this.stopRecordingProcess(); // 停止录制。
  // }
}