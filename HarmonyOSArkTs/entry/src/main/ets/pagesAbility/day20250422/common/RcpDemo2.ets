import { rcp } from '@kit.RemoteCommunicationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo, fileUri } from '@kit.CoreFileKit';
import { efRcp, efRcpClientApi, efRcpConfig } from 'myrcp';
import { IResponse, IUploadResData } from './RcpDemo1';
import { common, Permissions } from '@kit.AbilityKit';
import { DateUtil, FileUtil, PermissionUtil, PhotoHelper, ToastUtil, WantUtil } from '@pura/harmony-utils';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { ProgressButton } from '@kit.ArkUI';
import { buffer } from '@kit.ArkTS';

//封装下载多张图片
async function saveImg22(filePath: string) {
  try {
    //1. 构建源文件URI
    let srcFileUri = filePath;
    let srcFileUris: Array<string> = [// 封装成数组
      srcFileUri
    ];
    //2. 定义相册创建配置：指定待保存照片的创建选项，包括文件后缀和照片类型，标题和照片子类型可选
    let photoCreationConfigs: Array<photoAccessHelper.PhotoCreationConfig> = [
      {
        title: 'test', // 相册显示的标题（可选） 可选
        fileNameExtension: 'jpeg', // 文件扩展名
        photoType: photoAccessHelper.PhotoType.IMAGE, // 文件类型为图片
        subtype: photoAccessHelper.PhotoSubtype.DEFAULT, //// 子类型（可选）
      }
    ];
    //3.调用快捷方法显示保存弹窗
    PhotoHelper.showAssetsCreationDialogEasy(srcFileUris, photoCreationConfigs)
    // //基于弹窗授权的方式获取媒体库的目标uri
    // //4. 显示系统弹窗获取用户选择的保存位置
    // let desFileUris: Array<string> = await phAccessHelper.showAssetsCreationDialog(srcFileUris, photoCreationConfigs);
    // // 将来源于应用沙箱的照片内容写入媒体库的目标uri
    // // 5. 打开目标文件（相册位置）
    // let desFile: fileIo.File = await fileIo.open(desFileUris[0], fileIo.OpenMode.WRITE_ONLY);
    // // 6. 打开源文件（应用沙箱）
    // let srcFile: fileIo.File = await fileIo.open(srcFileUri, fileIo.OpenMode.READ_ONLY);
    // // 7. 执行文件内容复制
    // await fileIo.copyFile(srcFile.fd, desFile.fd);
    // // 8. 关闭文件描述符
    // fileIo.closeSync(srcFile);
    // fileIo.closeSync(desFile);
    // console.info('create asset by dialog successfully');
  } catch (err) {
    console.error(`failed to create asset by dialog successfully errCode is: ${err.code}, ${err.message}`);
  }
}


/**
 * 获取沙箱路径下的文件
 * @param path
 * @returns
 */
export function getSandboxPath(path: string) {
  return `${getContext().filesDir}/${path}`;
}
/**
 * 使用创建方式打开沙箱目录下的文件，将相册文件copy到沙箱目录下的文件
 * @param srcPath
 * @param destPath
 */
export function copyFileSync(srcPath: string, destPath: string) {
  const srcFile = fileIo.openSync(srcPath, fileIo.OpenMode.READ_ONLY);
  const destFile = fileIo.openSync(destPath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
  fileIo.copyFileSync(srcFile.fd, destFile.fd);
  fileIo.closeSync(srcFile);
  fileIo.closeSync(destFile);
}

/**
 * 将相册uris,创建复制到沙箱目录并返回
 * @param filePaths
 * @returns
 */
function mediaFileToStorageFile(filePaths: Array<string>) {
  return filePaths.map(filePath => {
    const imageName = filePath.split('/').pop() || '';
    const sandboxPath = getSandboxPath(imageName);
    copyFileSync(filePath, sandboxPath);
    return sandboxPath;
  });
}
@Entry
@Component
export struct RcpDemo2 {
  @State message: string = 'efRcp';
  //相册保存常量
  @State uriStr: string = ''
  //图片上传参数
  @State progressIndex: number = 0
  @State ButtonWidth: number = 200
  @State textState: string = '上传文件'
  @State enableState: boolean = true
  @State isRunning: boolean = false

  //图片保存沙箱函数
  async testDownloadFile(fileName: string) {
    await efRcpClientApi.downloadFile<IResponse<string>>({
      url: 'https://img1.baidu.com/it/u=3001150338,397170470&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1422',
      fileName: fileName
    }).then((res) => {
      //根路径
      let filesDir = (getContext() as common.UIAbilityContext).filesDir; //app 文件目录
      //获取文件全路径
      let filePath = filesDir + "/" + fileName; // app文件目录+文件名
      console.log('filePath:' + filePath)
      // saveImg22(filePath)  // 通过安全控件或授权弹窗的方式，将用户指定的媒体资源保存到图库中。
      this.save(filePath) //受限访问授权存取图片
      console.log('图片下载成功：' + res)
      this.message = JSON.stringify(res);
    }).catch((err: Error) => {
      console.log('图片下载报错：' + err.message)
    })

  }

  //图片保存进相册（已申请权限使用该方法）
  save(filePath: string) {
    // 1. 定义需要申请的权限：写入媒体文件的权限
    let ps: Permissions[] = ['ohos.permission.WRITE_IMAGEVIDEO'];
    // 2. 请求权限
    PermissionUtil.requestPermissions(ps).then((result) => {
      // 3. 权限申请结果处理
      if (result) { // 权限已授予
        // 4. 生成带时间戳的图片名称
        let imgName = `漂亮小姐姐_${DateUtil.getTodayTime()}`;
        // 5. 使用相册工具创建相册条目（此时相册中会生成一个空文件）
        PhotoHelper.save(
          photoAccessHelper.PhotoType.IMAGE, // 文件类型为图片
          'jpg', // 图片格式
          { title: imgName })// 文件名参数
          .then(async (uri) => {
            if (uri) { // 成功获取相册文件URI
              this.uriStr = `保存图片成功，返回uris：\n${uri}` // 6. 更新界面显示保存成功的URI
              // 7. 同步打开相册文件获取文件描述符
              let file = FileUtil.openSync(uri);
              // 8. 将下载的图片内容复制到相册文件
              FileUtil.copyFile(filePath, file.fd).then(() => {
                FileUtil.close(file.fd);
                ToastUtil.showToast("图片保存成功");
              })
            }
          }).catch((err: BusinessError) => {
          this.uriStr = `调用保存图片，异常：\n${JSON.stringify(err)}`
        })
      } else {
        ToastUtil.showLong("请在设置中打开权限")
        WantUtil.toAppSetting()
      }
    })
  }

  //图片上传
  async testUploadFile() {
    //此处演示需要使用上传进度时再去设置,全局只需要设置一次即可
    efRcp
      .setUploadEvent({
        onUploadProgress: (progress) => {
          this.progressIndex = progress
          console.log("---------测试上传进度----------", progress + "%")
        }
      })//切记需要调用create重新创建session否则设置不生效
      .create();
    efRcpConfig.token.tokenName = "Authorization"
    efRcpConfig.token.tokenValue =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySW5mbyI6eyJ1c2VySWQiOjIsInVzZXJuYW1lIjoiYWRtaW4iLCJuaWNrbmFtZSI6Iuezu-e7n-euoeeQhuWRmCIsImRlcHRJZCI6MSwicm9sZXMiOiJBRE1JTiJ9LCJpc3MiOiJkeXM2MjMwIiwiZXhwIjoxNzQ1NTMzMDcyLCJuYmYiOjE3NDU0OTcwNzIsImlhdCI6MTc0NTQ5NzA3Mn0.Oh4Fs0Y9qPir9hDJKBuT-63w_sGtid8xPWwEbwMvMzk"
    let arr = getContext().resourceManager.getMediaContentSync($r("app.media.imgs").id);
    // getContext().bundleCodeDir
    // getContext().filesDir // files 通用的存放默认长期保存的文件路径
    // getContext().cacheDir //cache 应用缓存文件路径
    console.log(`{buffer.from(arr).buffer.byteLength:${buffer.from(arr).buffer.byteLength}`)
    //上传
    let dto =
      await efRcpClientApi.uploadFile<IResponse<IUploadResData>>({
        url: '/files',
        fileInfo: {
          "file": {
            contentType: 'multipart/form-data',
            remoteFileName: 'newRcp.png',
            contentOrPath: {
              content: buffer.from(arr).buffer
            }
          }
        }
      });
    this.message = JSON.stringify(dto);
  }

  //使用相册图片进行上传
  async testUploadFile2(src: string) {
    // 获取文件名
    let fName = new fileUri.FileUri(src).name;
    console.log(`fName::${fName}`)
    //此处演示需要使用上传进度时再去设置,全局只需要设置一次即可
    efRcp
      .setUploadEvent({
        onUploadProgress: (progress) => {
          this.progressIndex = progress
          console.log("---------测试上传进度----------", progress + "%")
        }
      })//切记需要调用create重新创建session否则设置不生效
      .create();
    efRcpConfig.token.tokenName = 'Authorization'
    efRcpConfig.token.tokenValue = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySW5mbyI6eyJ1c2VySWQiOjIsInVzZXJuYW1lIjoiYWRtaW4iLCJuaWNrbmFtZSI6Iuezu-e7n-euoeeQhuWRmCIsImRlcHRJZCI6MSwicm9sZXMiOiJBRE1JTiJ9LCJpc3MiOiJkeXM2MjMwIiwiZXhwIjoxNzQ2NTMwNjAwLCJuYmYiOjE3NDY0OTQ2MDAsImlhdCI6MTc0NjQ5NDYwMH0.ggB-jwSQkzuBVeFd0uR8u3Gdfcj1168VgpLjFSKL8I4"
    //上传
    let dto =
      await efRcpClientApi.uploadFile<IResponse<IUploadResData>>({
        url: '/files',
        fileInfo: {
          "file": {
            contentType: 'multipart/form-data',
            remoteFileName: fName,
            contentOrPath: src  // 沙箱路径地址string 直接复制给contentOrPath属性
          }
        }
      });
    console.log(JSON.stringify(dto))
    this.message = JSON.stringify(dto);
  }

  build() {
    Scroll() {
      Column({ space: 10 }) {
        Text(this.message)
          .id('RcpDemo3HelloWorld')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
        Image('file://com.tianqing.zhongyi/data/storage/el2/base/haps/entry/files/2025_02_20_10_24_23_7758_2.jpeg')
          .width(100)
        //原生文件下载
        Column() {
          Button('原生原生下载-downloadFile')
            .onClick(() => {
              const DOWNLOAD_TO_PATH = getContext().filesDir
              let downloadToFile: rcp.DownloadToFile = {
                kind: 'folder',
                path: DOWNLOAD_TO_PATH //请根据自身业务选择合适的路径
              } as rcp.DownloadToFile
              const session = rcp.createSession();
              session.downloadToFile("https://sanjitian-1256310189.cos.ap-chengdu.myqcloud.com/gin_test/2025/02/2025_02_19_15_36_08_2712_2.jpg",
                downloadToFile).then((response) => {
                console.info(`Succeeded in getting the response ${response}`);
              }).catch((err: BusinessError) => {
                console.error(`DownloadToFile failed, the error message is ${JSON.stringify(err)}`);
              });
            })
        }
        .borderWidth(2)
        .padding(5)

        //下载图片保存到相册
        Column() {
          Button('下载-downloadFile')
            .onClick(() => {
              efRcp
                .setDownLoadEvent({
                  onDownloadProgress: (progress) => {
                    console.log("---------测试下载进度----------", progress + "%")
                  }
                })//切记需要调用create重新创建session否则设置不生效
                .create()
              //此处演示需要使用下载进度时再去设置,全局只需要设置一次即可
              this.testDownloadFile('2025_02_20_10_24_23_7758_2.jpeg')
            })
        }
        .borderWidth(2)
        .padding(5)

        //图片上传
        Column() {
          ProgressButton({
            progress: this.progressIndex,
            progressButtonWidth: this.ButtonWidth,
            content: this.textState,
            enable: this.enableState,
            clickCallback: async () => {
              this.isRunning = !this.isRunning
              await this.testUploadFile();
            }
          })
          Button('上传-testUploadFile')
            .onClick(async () => {
              await this.testUploadFile();
            })
        }
        .borderWidth(2)
        .padding(5)
        //使用相册图片上传
        Column() {
          Text(this.uriStr)
            .textStyle()
          Button('使用相册上传')
            .onClick(() => {
              //相册选择图片/视频
              PhotoHelper.select().then((uris) => {
                console.log('相册调用成功：' + JSON.stringify(uris));
                // 使用沙箱路径
                const storageFiles = mediaFileToStorageFile(uris)
                console.log('storageFiles:' + JSON.stringify(storageFiles))
                this.testUploadFile2(storageFiles[0])
                // 直接相册图片路径(不行，需copy到沙箱路径)
                // this.testUploadFile2(uris[0])
                this.uriStr = `调用相册，返回uris：\n${uris.join('\n')}`;
              }).catch((err: BusinessError) => {
                this.uriStr = `调用相册，异常：\n${JSON.stringify(err)}`;
              });
            })
        }
        .borderWidth(2)
        .padding(5)
      }
    }
    .height('100%')
    .width('100%')
  }
}

@Styles
function textStyle() {
  .width('95%')
  .padding(10)
  .shadow(ShadowStyle.OUTER_DEFAULT_XS)
  .margin({ top: 5, bottom: 10 })
  .border({
    width: 1,
    color: Color.Grey,
    radius: 10,
    style: BorderStyle.Dashed
  })
}
