// album.js

let currentContextTarget = null; // 当前右键操作对象（文件夹或照片）
let currentContextType = null;   // 类型：'folder' | 'photo' | 'blank'
let currentPhotoId = null;       // 当前选中照片ID，用于删除等操作
let currentFolderId = null;      // 当前选中文件夹ID，用于删除等操作
let modalActionType = null;      // 'rename_folder' | 'rename_photo' | 'create_folder'

// Bootstrap Modal 实例
const modalDialog = new bootstrap.Modal(document.getElementById('modalDialog'));
const modalInput = document.getElementById('modalInput');
const modalTitle = document.querySelector('#modalDialog .modal-title');

// ------------------- 弹出消息封装 -------------------
const alertContainer = document.getElementById('alert-container');

function showMessage(type, message) {
  /*
  type: 'info' | 'success' | 'warning' | 'danger'
  message: 文本内容
  */
  const colors = {
    info: 'alert-info',
    success: 'alert-success',
    warning: 'alert-warning',
    danger: 'alert-danger'
  };
  const id = `msg_${Date.now()}_${Math.random().toString(36).slice(2)}`;
  const alertDiv = document.createElement('div');
  alertDiv.id = id;
  alertDiv.className = `alert ${colors[type] || colors.info} alert-dismissible fade show`;
  alertDiv.style.minWidth = '250px';
  alertDiv.style.marginBottom = '0.5rem';
  alertDiv.role = 'alert';
  alertDiv.innerHTML = `
    ${message}
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
  `;
  alertContainer.appendChild(alertDiv);

  // 10秒后自动渐隐并移除
  setTimeout(() => {
    alertDiv.classList.remove('show');
    alertDiv.classList.add('fade-out');
    alertDiv.addEventListener('animationend', () => {
      alertDiv.remove();
    });
  }, 10000);
}

// ------------------- 上传图片 -------------------
function Toupload() {
  const fileInput = document.getElementById('file');
  if (!fileInput.value) {
    showMessage('warning', '未上传图片！');
    return;
  }

  const allowedExt = ['jpg', 'jpeg', 'png', 'mp4'];
  const ext = fileInput.value.split('.').pop().toLowerCase();
  if (!allowedExt.includes(ext)) {
    showMessage('danger', '图片格式错误，请重新上传');
    fileInput.value = '';
    return;
  }

  const formData = new FormData(document.getElementById('form'));

  $.ajax({
    url: "{% url 'upload_file' %}",
    method: "POST",
    data: formData,
    processData: false,
    contentType: false,
    success: function(data) {
      showMessage('success', data.message || '上传成功');
      location.reload();
    },
    error: function(err) {
      showMessage('danger', '上传失败，请重试');
      console.error(err);
    }
  });
}

// ------------------- 删除照片 -------------------
function Delete(file_id) {
  if (!file_id) {
    showMessage('warning', '未选择文件');
    return;
  }
  if (!confirm('确认删除吗？')) return;

  $.ajax({
    url: "{% url 'delete_file' %}",
    type: "POST",
    data: {
      _method: "DELETE",
      csrfmiddlewaretoken: document.getElementsByName("csrfmiddlewaretoken")[0].value,
      id: file_id,
    },
    success: function(data) {
      showMessage('success', data.message || '删除成功');
      location.reload();
    },
    error: function(err) {
      showMessage('danger', '删除失败');
      console.error(err);
    }
  });
}

// ------------------- 打开照片查看 -------------------
function Pic(file_url) {
  window.open(file_url, '_blank');
}

// ------------------- 右键菜单显示控制 -------------------
const folderMenu = $('#folderContextMenu');
const photoMenu = $('#photoContextMenu');
const blankMenu = $('#blankContextMenu');

$(document).ready(() => {
  // 加载文件夹和照片示例（实际应由后端渲染或通过API加载）
  // 此处略，仅实现右键逻辑

  // 禁用浏览器默认右键菜单
  $(document).on('contextmenu', e => {
    e.preventDefault();
    hideAllContextMenus();

    let $target = $(e.target);
    // 判断点击目标属于哪个区域
    if ($target.closest('.folder-card').length) {
      currentContextType = 'folder';
      currentContextTarget = $target.closest('.folder-card');
      currentFolderId = currentContextTarget.data('folder-id');
      showContextMenu(folderMenu, e.pageX, e.pageY);
    } else if ($target.closest('.photo-card').length) {
      currentContextType = 'photo';
      currentContextTarget = $target.closest('.photo-card');
      currentPhotoId = currentContextTarget.data('photo-id');
      showContextMenu(photoMenu, e.pageX, e.pageY);
    } else {
      currentContextType = 'blank';
      currentContextTarget = null;
      showContextMenu(blankMenu, e.pageX, e.pageY);
    }
  });

  // 点击其他区域隐藏右键菜单
  $(document).on('click', () => {
    hideAllContextMenus();
  });

  // 绑定拖拽事件
  bindDragAndDrop();
});

// 显示指定菜单，传入jQuery对象和坐标
function showContextMenu($menu, x, y) {
  $menu.css({top: y, left: x}).addClass('show');
}
// 隐藏所有菜单
function hideAllContextMenus() {
  folderMenu.removeClass('show');
  photoMenu.removeClass('show');
  blankMenu.removeClass('show');
}

// ------------------- 模态框操作 -------------------
function openRenameModal(type) {
  modalActionType = type === 'folder' ? 'rename_folder' : 'rename_photo';
  modalTitle.textContent = '重命名';
  modalInput.value = '';
  modalInput.placeholder = '请输入新名称';
  modalDialog.show();
}

function openCreateFolderModal() {
  modalActionType = 'create_folder';
  modalTitle.textContent = '新建文件夹';
  modalInput.value = '';
  modalInput.placeholder = '请输入文件夹名称';
  modalDialog.show();
}

function submitModalAction() {
  const val = modalInput.value.trim();
  if (!val) {
    showMessage('warning', '输入不能为空');
    return;
  }

  if (modalActionType === 'rename_folder') {
    if (!currentFolderId) {
      showMessage('danger', '文件夹未选中');
      modalDialog.hide();
      return;
    }
    // Ajax 请求重命名文件夹接口
    $.ajax({
      url: "{% url 'rename_folder' %}",
      type: 'POST',
      data: {
        csrfmiddlewaretoken: document.getElementsByName("csrfmiddlewaretoken")[0].value,
        id: currentFolderId,
        new_name: val
      },
      success: function(data) {
        showMessage('success', data.message || '重命名成功');
        location.reload();
      },
      error: function() {
        showMessage('danger', '重命名失败');
      }
    });
  } else if (modalActionType === 'rename_photo') {
    if (!currentPhotoId) {
      showMessage('danger', '照片未选中');
      modalDialog.hide();
      return;
    }
    $.ajax({
      url: "{% url 'rename_photo' %}",
      type: 'POST',
      data: {
        csrfmiddlewaretoken: document.getElementsByName("csrfmiddlewaretoken")[0].value,
        id: currentPhotoId,
        new_name: val
      },
      success: function(data) {
        showMessage('success', data.message || '重命名成功');
        location.reload();
      },
      error: function() {
        showMessage('danger', '重命名失败');
      }
    });
  } else if (modalActionType === 'create_folder') {
    $.ajax({
      url: "{% url 'create_folder' %}",
      type: 'POST',
      data: {
        csrfmiddlewaretoken: document.getElementsByName("csrfmiddlewaretoken")[0].value,
        folder_name: val
      },
      success: function(data) {
        showMessage('success', data.message || '新建文件夹成功');
        location.reload();
      },
      error: function() {
        showMessage('danger', '新建文件夹失败');
      }
    });
  }

  modalDialog.hide();
}

// ------------------- 删除文件夹 -------------------
function deleteFolder() {
  if (!currentFolderId) {
    showMessage('warning', '未选择文件夹');
    return;
  }

  // 先检测文件夹是否为空
  $.ajax({
    url: "{% url 'check_folder_empty' %}",
    method: 'GET',
    data: { id: currentFolderId },
    success: function(data) {
      if (data.is_empty) {
        if (!confirm('确认删除该空文件夹吗？')) return;

        // 删除文件夹
        $.ajax({
          url: "{% url 'delete_folder' %}",
          method: 'POST',
          data: {
            csrfmiddlewaretoken: document.getElementsByName("csrfmiddlewaretoken")[0].value,
            id: currentFolderId
          },
          success: function(data) {
            showMessage('success', data.message || '删除成功');
            location.reload();
          },
          error: function() {
            showMessage('danger', '删除失败');
          }
        });
      } else {
        showMessage('warning', '文件夹不为空，无法删除');
      }
    },
    error: function() {
      showMessage('danger', '检测文件夹状态失败');
    }
  });
}

// ------------------- 查看照片信息 -------------------
function viewPhotoInfo() {
  if (!currentPhotoId) {
    showMessage('warning', '未选择照片');
    return;
  }

  // 这里可以改为弹出详细信息模态框，这里简易用alert替代
  $.ajax({
    url: "{% url 'photo_info' %}",
    method: "GET",
    data: { id: currentPhotoId },
    success: function(data) {
      // 你可以自己定义显示方式，这里简单alert
      alert(`照片名称: ${data.name}\n上传时间: ${data.upload_time}\n大小: ${data.size}`);
    },
    error: function() {
      showMessage('danger', '获取照片信息失败');
    }
  });
}

// ------------------- 拖拽照片到文件夹 -------------------
function bindDragAndDrop() {
  // 可拖拽的照片
  $('.photo-card').attr('draggable', true);

  $(document).on('dragstart', '.photo-card', function(e) {
    e.originalEvent.dataTransfer.setData('photoId', $(this).data('photo-id'));
  });

  // 文件夹拖放目标
  $(document).on('dragover', '.folder-card', function(e) {
    e.preventDefault();
    $(this).addClass('drag-over');
  });

  $(document).on('dragleave drop', '.folder-card', function(e) {
    e.preventDefault();
    $(this).removeClass('drag-over');
  });

  $(document).on('drop', '.folder-card', function(e) {
    e.preventDefault();
    const photoId = e.originalEvent.dataTransfer.getData('photoId');
    const folderId = $(this).data('folder-id');
    if (!photoId || !folderId) {
      showMessage('warning', '操作失败，缺少必要信息');
      return;
    }
    movePhotoToFolder(photoId, folderId);
  });
}

// 调用后端接口移动照片到文件夹
function movePhotoToFolder(photoId, folderId) {
  $.ajax({
    url: "{% url 'move_photo_to_folder' %}",
    type: 'POST',
    data: {
      csrfmiddlewaretoken: document.getElementsByName("csrfmiddlewaretoken")[0].value,
      photo_id: photoId,
      folder_id: folderId
    },
    success: function(data) {
      showMessage('success', data.message || '移动成功');
      location.reload();
    },
    error: function() {
      showMessage('danger', '移动失败');
    }
  });
}
