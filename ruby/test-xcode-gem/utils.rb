# require 'FileUtils'
require 'find'

module Utils
    class XGSDK
        
        class << self
        #  this is all define begin...
        
        def sayHello
            p "hello"
        end
        
        def getProductGroup(proj)
            if proj.products_group==nil
                product_group = Utils::XGSDK.creatNewGroup(proj,"xg_products")
                else
                product_group =proj.products_group
            end
        end
        
        # 将sourceDir目录下的所有文件夹下的所有文件，拷贝到destDir(dest目录不存在时，自动创建)
        def copyAllFile(sourceDir,destDir)
            p File.directory?(destDir)
            if (!File.directory?(destDir))
                p "will create dir.."
                Dir::mkdir(destDir)
            end
            list=[]
            Find.find(sourceDir) do |f|
                list << f
            end
            list.sort
            # p list
            list.each_index do |x|
                if (!File.directory?(list[x]))
                    # p "file is ..."+list[x]
                    FileUtils.cp"#{list[x]}" , destDir
                end
            end
        end
        
        
        def buildTagFile(src_file,tag_file)
            tagFile = File.new(tag_file,"w");
            p "add tag..."
            File.open(src_file,"r") do |file|
                while line  = file.gets
                    if line.include?"<integer>"
                        p "convert ingeger tag..."
                        line= line.gsub(/<integer>/,'<string>')
                        line= line.gsub(/<\/integer>/,"xgsdk_package_tag"+'</string>')
                    end
                    tagFile.puts line
                end
            end
            tagFile.close #只有close掉了内容才被写入文件里面。
        end
        
        
        def deleteFiles(fileList)
            for file in fileList
                File.delete(file)
            end
        end
        
        
        def buildDestFile(tag_file,dest_file)
            destFile = File.new(dest_file,"w");
            File.open(tag_file,"r") do |file|
                while line  = file.gets
                    if line.include?"xgsdk_package_tag"
                        line= line.gsub(/<string>/,'<integer>')
                        line= line.gsub(/xgsdk_package_tag<\/string>/,'</integer>')
                    end
                    destFile.puts line
                end
            end
            destFile.close #只有close掉了内容才被写入文件里面。
        end
        
        
        
        def findBasicTarget(proj,targetName)
            basicTarget=nil
            for target in proj.targets
                if target.name+".xcodeproj" == targetName then
                    basicTarget = target
                end
            end
            return basicTarget;
        end
        
        
        
        def clearOldTarget(proj,sdkTargetName)
            newTarget=nil
            for target in proj.targets
                if target.name == sdkTargetName then
                    newTarget = target
                end
            end
            #delete old target
            if newTarget!=nil
                p "delete: old target..."
                proj.targets.delete(newTarget)
                newTarget=nil
            end
            return newTarget
        end
        
        
        
        def clearOldProduct(proj,sdkProductName)
            # find product
            newProduct=nil
            p "product is ..."
            p proj.products_group
            if proj.products_group!=nil
                for product in proj.products
                    if product.path == sdkProductName
                        newProduct = product
                    end
                end
                
                # delete old product
                if newProduct!=nil
                    p "delete: old product..."
                    proj.products.delete(newProduct)
                    newProduct=nil
                end
            end
            return newProduct
        end
        
        
        def creatNewGroup(proj,sdkGroupName)
            newGroup = nil
            sdk_group = nil
            for group in proj.groups
                if group.name == sdkGroupName then
                    newGroup = group
                end
            end
            sdk_group=nil
            if newGroup==nil
                sdk_group = proj.new_group(sdkGroupName,nil)
                else
                sdk_group = newGroup
            end
            return sdk_group
        end
        
        
        
        
        def copyBuildPhase(newTarget,proj,basicTarget)
            p "copy: source file..."
            newTarget.source_build_phase.files.clear
            for file in basicTarget.source_build_phase.files
                newBuildFile=proj.new("PBXBuildFile")
                newBuildFile.file_ref=file.file_ref
                newBuildFile.settings={}
                if file.settings!=nil
                    newBuildFile.settings['COMPILER_FLAGS'] = file.settings['COMPILER_FLAGS']
                end
                newTarget.source_build_phase.files << newBuildFile
            end
            
            p "copy: build lib and framwoks..."
            newTarget.frameworks_build_phase.files.clear
            for file in basicTarget.frameworks_build_phase.files
                newTarget.frameworks_build_phase.files << file
            end
            
            p "copy: build resources..."
            newTarget.resources_build_phase.files.clear
            for file in basicTarget.resources_build_phase.files
                newTarget.resources_build_phase.files << file
            end

            p "copy: run script ..."
            newTarget.shell_script_build_phases.clear
            for file1 in basicTarget.shell_script_build_phases
                tempScriptObject = newTarget.new_shell_script_build_phase
                tempScriptObject.name=file1.name
                tempScriptObject.input_paths=file1.input_paths
                tempScriptObject.output_paths=file1.output_paths
                tempScriptObject.shell_path=file1.shell_path
                tempScriptObject.shell_script=file1.shell_script
                tempScriptObject.show_env_vars_in_log=file1.show_env_vars_in_log
                tempScriptObject.run_only_for_deployment_postprocessing=file1.run_only_for_deployment_postprocessing
            end            
        end
        
        def copyBuildSetting(newTarget,basicTarget)
            newTarget.build_settings("Debug").clear
            debug_list = basicTarget.build_settings("Debug")
            copy_debug_list=Marshal.load(Marshal.dump(debug_list))
            #              p copy_debug_list
            newTarget.build_settings("Debug").update(copy_debug_list)
            
            newTarget.build_settings("Release").clear
            release_list = basicTarget.build_settings("Release")
            copy_release_list=Marshal.load(Marshal.dump(release_list))
            #              p copy_release_list
            newTarget.build_settings("Release").update(copy_release_list)
        end
        
        def addOtherLinkFlag(newTarget,flagList)
            flagList1 = newTarget.build_settings("Debug")
            flagList2 = newTarget.build_settings("Release")
            Utils::XGSDK.addHashwithListValue(flagList1,"OTHER_LDFLAGS","$(inherited)")
            Utils::XGSDK.addHashwithListValue(flagList2,"OTHER_LDFLAGS","$(inherited)")
            for flag in flagList
                Utils::XGSDK.addHashwithListValue(flagList1,"OTHER_LDFLAGS",flag)
                Utils::XGSDK.addHashwithListValue(flagList2,"OTHER_LDFLAGS",flag)
            end
        end
        
        def  addLibSearchPath(newTarget,pathLit)
            flagList1 = newTarget.build_settings("Debug")
            flagList2 = newTarget.build_settings("Release")
            Utils::XGSDK.addHashwithListValue(flagList1,"LIBRARY_SEARCH_PATHS","$(inherited)")
            Utils::XGSDK.addHashwithListValue(flagList2,"LIBRARY_SEARCH_PATHS","$(inherited)")
            for path in pathLit
                Utils::XGSDK.addHashwithListValue(flagList1,"LIBRARY_SEARCH_PATHS",path)
                Utils::XGSDK.addHashwithListValue(flagList2,"LIBRARY_SEARCH_PATHS",path)
            end
            
        end
        
        
        
        def addHeaderSearchPath(newTarget,pathLit)
            flagList1 = newTarget.build_settings("Debug")
            flagList2 = newTarget.build_settings("Release")
            Utils::XGSDK.addHashwithListValue(flagList1,"HEADER_SEARCH_PATHS","$(inherited)")
            Utils::XGSDK.addHashwithListValue(flagList2,"HEADER_SEARCH_PATHS","$(inherited)")
            for path in pathLit
                Utils::XGSDK.addHashwithListValue(flagList1,"HEADER_SEARCH_PATHS",path)
                Utils::XGSDK.addHashwithListValue(flagList2,"HEADER_SEARCH_PATHS",path)
            end
        end
        
        def  addFrameSearchPath(newTarget,pathLit)
            flagList1 = newTarget.build_settings("Debug")
            flagList2 = newTarget.build_settings("Release")
             Utils::XGSDK.addHashwithListValue(flagList1,"FRAMEWORK_SEARCH_PATHS","$(inherited)")
            Utils::XGSDK.addHashwithListValue(flagList2,"FRAMEWORK_SEARCH_PATHS","$(inherited)")
            for path in pathLit
                Utils::XGSDK.addHashwithListValue(flagList1,"FRAMEWORK_SEARCH_PATHS",path)
                Utils::XGSDK.addHashwithListValue(flagList2,"FRAMEWORK_SEARCH_PATHS",path)
            end
            
        end
        
        def updateARCFlag(newTarget,flag)
            flagList1 = newTarget.build_settings("Debug")
            flagList2 = newTarget.build_settings("Release")
            flagList1["CLANG_ENABLE_OBJC_ARC"] =flag
            flagList2["CLANG_ENABLE_OBJC_ARC"] =flag
        end
        
        
        # otherLinkFlag 这种setting存在两种可能的类型。单个时为string，多个时为Array
        def addHashwithListValue(hashList,key,value)
            temp_list = []
            if hashList[key]==nil
                hashList[key]=value
                return
            end
            if !hashList[key].include?value
                if hashList[key].class == Array
                    hashList[key]<<value
                    else
                    temp_list<<hashList[key]
                    temp_list<<value
                    hashList[key]=temp_list
                end
            end
        end
        
         def  disableBitCodeFlag(newTarget)
            flagList1 = newTarget.build_settings("Debug")
            flagList2 = newTarget.build_settings("Release")
            flagList1["ENABLE_BITCODE"] ="NO"
            flagList2["ENABLE_BITCODE"] ="NO"
        end
        
        
        
        def createHashValue(hashList,key,value)
            hashList[key]=value
        end
        
        def isFileExist(fileList,fileName)
            ret = "no"
            if fileList.size==0
                return ret
            end
            
            for file in fileList
                if file.display_name == fileName
                    ret= "yes"
                    break;
                end
            end
            # p fileName+" exist flag is: "+ret
            return ret;
        end
        
        
        def resetIconPath(newTarget,channelId)
            list1 = newTarget.build_settings("Debug")
            list2 = newTarget.build_settings("Release")
            list1["ASSETCATALOG_COMPILER_LAUNCHIMAGE_NAME"]="LaunchImage_"+channelId
            list1["ASSETCATALOG_COMPILER_APPICON_NAME"]="AppIcon_"+channelId
            list2["ASSETCATALOG_COMPILER_LAUNCHIMAGE_NAME"]="LaunchImage_"+channelId
            list2["ASSETCATALOG_COMPILER_APPICON_NAME"]="AppIcon_"+channelId
        end
        
        def addRunSearchPath(newTarget,path)
            list1 = newTarget.build_settings("Debug")
            list2 = newTarget.build_settings("Release")
            list1["LD_RUNPATH_SEARCH_PATHS"]=path
            list2["LD_RUNPATH_SEARCH_PATHS"]=path
        end
        
        def addCPlusLibConfig(newTarget,lib)
            list1 = newTarget.build_settings("Debug")
            list2 = newTarget.build_settings("Release")
            list1["CLANG_CXX_LIBRARY"]=lib
            list2["CLANG_CXX_LIBRARY"]=lib
        end
        
        def addCodeSignPath(newTarget,path)
            list1 = newTarget.build_settings("Debug")
            list2 = newTarget.build_settings("Release")
            list1["CODE_SIGN_RESOURCE_RULES_PATH"]=path
            list2["CODE_SIGN_RESOURCE_RULES_PATH"]=path
        end
        
        
        def setBuildPharse(newTarget,sdk_group,path)
            fileName = path.split('/')[-1]
            # flag = Utils::XGSDK.isFileExist(sdk_group.files,fileName)
            
            lib=nil
            for file in sdk_group.files
                if file.display_name == fileName
                    lib= file
                    break;
                end
            end
            
            if lib==nil
                p "will add new file to group..."
                lib=sdk_group.new_file(path)
            end
            
            flag = Utils::XGSDK.isFileExist(newTarget.frameworks_build_phase.files,fileName)
            if flag=="no"
                # lib=sdk_group.new_file(path)
                newTarget.frameworks_build_phase.add_file_reference(lib,true);
                p "-->"+fileName+" is added successfully..."
            end
        end
        
        
        def setResoucePharse(newTarget,sdk_group,path)
            fileName = path.split('/')[-1]
            # flag = Utils::XGSDK.isFileExist(sdk_group.files,fileName)
            res=nil
            for file in sdk_group.files
                if file.display_name == fileName
                    res= file
                    break
                end
            end
            
            if res==nil
                p "will add new file to group..."
                res=sdk_group.new_file(path)
            end
            
            flag = Utils::XGSDK.isFileExist(newTarget.resources_build_phase.files,fileName)
            
            if flag=="no"
                # res = sdk_group.new_file(path)
                newTarget.resources_build_phase.add_file_reference(res,true);
                p "-->"+fileName+" is added successfully..."
            end
        end
        
        
        def setSourceFilePharse(newTarget,sdk_group,path)
            fileName = path.split('/')[-1]
#            flag = Utils::XGSDK.isFileExist(sdk_group.files,fileName)
            src=nil
            for file in sdk_group.files
                if file.display_name == fileName
                    src= file
                    break
                end
            end
            
            if src==nil
                p "will add new file to group..."
                src=sdk_group.new_file(path)
            end
            
            flag = Utils::XGSDK.isFileExist(newTarget.source_build_phase.files,fileName)
            
            if flag=="no"
#                src = sdk_group.new_file(path)
                newTarget.source_build_phase.add_file_reference(src,true);
                p "-->"+fileName+" is added successfully..."
            end
        end
        
        
        def makeUnitySetting(project_path,proj,newTarget)
            data_path = project_path+"/Data"
            is_unity_flag = File.exist?(data_path)
            if is_unity_flag
                p "unity platform is true, will do..."
                
                p "----1. add unity data path ----"
                fileName = data_path.split('/')[-1]
                flag2 = Utils::XGSDK.isFileExist(newTarget.resources_build_phase.files,fileName)
                res =nil
                for file in proj.files
                    if file.path == fileName
                        res= file
                        break
                    end
                end
                if res==nil
                    p "will add new data folder..."
                    res = proj.new_file(data_path)
                end
                if flag2 =="no"
                    newTarget.resources_build_phase.add_file_reference(res,true);
                    p "-->"+fileName+" is added successfully..."
                end
                
                
                p "----2. add unity Libraries path ----"
                lib_search_settings_debug=newTarget.build_settings("Debug")["LIBRARY_SEARCH_PATHS"]
                lib_search_settings_release=newTarget.build_settings("Release")["LIBRARY_SEARCH_PATHS"]
                Utils::XGSDK.deletePathQuote(lib_search_settings_debug);
                Utils::XGSDK.deletePathQuote(lib_search_settings_release);
                p "unity add ok...."
            end
        end
        
        
        
        
        def deletePathQuote(lib_search_settings_release)
            lib_search_settings_release.each_index do |x|
                if lib_search_settings_release[x]=="\"$(SRCROOT)/Libraries\""
                    lib_search_settings_release[x]= "$(SRCROOT)/Libraries"
                    break
                end
            end
        end
        
        #  this is all define end...
    end
end
end