<#import "template.ftl" as layout>

<@layout.registrationLayout; section>
    <#if section = "header">
        <h1>ATOMSKILLS 2025</h1>

    <#elseif section = "form">
        <#-- Вставляем оригинальную форму входа -->
        <form id="kc-form-login" action="${url.loginAction}" method="post">
            <div class="${properties.kcFormGroupClass!}">
                <label for="username" class="${properties.kcLabelClass!}">Логин</label>
                <input type="text" id="username" name="username" class="${properties.kcInputClass!}" autofocus>
            </div>

            <div class="${properties.kcFormGroupClass!}">
                <label for="password" class="${properties.kcLabelClass!}">Пароль</label>
                <input type="password" id="password" name="password" class="${properties.kcInputClass!}">
            </div>

            <div class="${properties.kcFormGroupClass!}">
                <input type="submit" value="Войти" class="${properties.kcButtonClass!}">
            </div>
        </form>

    <#elseif section = "message">
        <#-- Сообщения об ошибках -->
        <#if message?has_content>
            <div class="alert alert-${message.type}">
                ${message.summary}
            </div>
        </#if>
    </#if>
</@layout.registrationLayout>