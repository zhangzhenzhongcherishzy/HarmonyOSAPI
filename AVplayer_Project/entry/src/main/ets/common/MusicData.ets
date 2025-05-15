import { util } from "@kit.ArkTS"
import { common } from "@kit.AbilityKit";

export function MusicData(Music:string){
  let value = (getContext() as common.UIAbilityContext).resourceManager.getRawFileContentSync(Music)//读取rawfile下的文件转成string
  let textDecoder:util.TextDecoder = util.TextDecoder.create()// 调用util模块的TextDecoder类
  let retStr = textDecoder.decodeToString(value);// 对Uint8Array解码
  let strBase64 = new util.Base64Helper().encodeToStringSync(value)
  console.log('retStr：' + retStr)
  console.log('strBase64：' + strBase64)
  let str:string[] = retStr.split('\n')
  console.log('str：' + str)
  return str
}